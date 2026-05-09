// Thin C wrapper γύρω από TFLite-Micro audio_microfrontend για Snorvy FFI.
// One-shot: feed 1-sec int16 audio → 49×40 uint16 log-mel-PCAN features.
// Bit-exact με το Python tf.lite.experimental.microfrontend (ίδιο C source).

#include <stdint.h>
#include <stdlib.h>
#include <string.h>

#include "tensorflow/lite/experimental/microfrontend/lib/frontend.h"
#include "tensorflow/lite/experimental/microfrontend/lib/frontend_util.h"

// Snorvy_FA_API_VERSION bumps when ABI changes — Dart side asserts match.
#define SNORVY_MF_API_VERSION 1

#if defined(__ANDROID__) || defined(__linux__)
#define SNORVY_MF_EXPORT __attribute__((visibility("default")))
#elif defined(_WIN32)
#define SNORVY_MF_EXPORT __declspec(dllexport)
#else
#define SNORVY_MF_EXPORT
#endif

SNORVY_MF_EXPORT int snorvy_mf_api_version(void) {
  return SNORVY_MF_API_VERSION;
}

/// Compute features για ένα audio buffer (one-shot — fresh state κάθε κλήση,
/// matching tf.audio_microfrontend default behaviour).
///
/// Inputs:
///   audio_in: int16 PCM, mono, sample_rate Hz
///   num_samples: length of audio_in
///   features_out: output buffer για uint16 features
///   max_features: capacity of features_out (≥ num_frames * num_channels)
///   sample_rate: 16000
///   window_size_ms: 30
///   window_step_ms: 20
///   num_channels: 40 (mel filterbank size)
///   lower_band_limit_hz: 125
///   upper_band_limit_hz: 7500
///   enable_pcan: 1 to enable per-channel auto normalization
///   enable_log: 1 to apply log scale
///
/// Returns: number of feature values written (= num_frames * num_channels),
///          or -1 on error.
SNORVY_MF_EXPORT int snorvy_mf_compute(
    const int16_t* audio_in,
    int num_samples,
    uint16_t* features_out,
    int max_features,
    int sample_rate,
    int window_size_ms,
    int window_step_ms,
    int num_channels,
    int lower_band_limit_hz,
    int upper_band_limit_hz,
    int enable_pcan,
    int enable_log) {
  if (audio_in == NULL || features_out == NULL) return -1;
  if (num_samples <= 0 || max_features <= 0) return -1;

  struct FrontendConfig config;
  FrontendFillConfigWithDefaults(&config);

  // Snorvy / adrianagaler tiny_conv parameters
  config.window.size_ms = window_size_ms;
  config.window.step_size_ms = window_step_ms;
  config.filterbank.num_channels = num_channels;
  config.filterbank.lower_band_limit = (float)lower_band_limit_hz;
  config.filterbank.upper_band_limit = (float)upper_band_limit_hz;
  config.noise_reduction.smoothing_bits = 10;
  config.filterbank.output_scale_shift = 7;
  config.log_scale.enable_log = enable_log ? 1 : 0;
  config.log_scale.scale_shift = 6;

  // PCAN gain control (defaults from FrontendFillConfigWithDefaults are
  // already correct: strength=0.95, offset=80, gain_bits=21).
  config.pcan_gain_control.enable_pcan = enable_pcan ? 1 : 0;

  struct FrontendState state;
  if (!FrontendPopulateState(&config, &state, sample_rate)) {
    return -1;
  }

  int written = 0;
  size_t consumed = 0;
  size_t remaining = (size_t)num_samples;
  const int16_t* cursor = audio_in;

  while (remaining > 0) {
    size_t num_read = 0;
    struct FrontendOutput output =
        FrontendProcessSamples(&state, cursor, remaining, &num_read);
    if (num_read == 0) break;
    cursor += num_read;
    remaining -= num_read;
    consumed += num_read;
    if (output.size == 0) continue;

    if (written + (int)output.size > max_features) {
      FrontendFreeStateContents(&state);
      return -1;
    }
    memcpy(features_out + written, output.values,
           output.size * sizeof(uint16_t));
    written += (int)output.size;
  }

  (void)consumed;
  FrontendFreeStateContents(&state);
  return written;
}

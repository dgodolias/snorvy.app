// Snorvy Tweaks panel
const SNORVY_DEFAULTS = /*EDITMODE-BEGIN*/{
  "theme": "midnight",
  "accent": "mint",
  "showFrame": true
}/*EDITMODE-END*/;

function SnorvyTweaks({ tweaks, setTweak }) {
  return (
    <TweaksPanel title="Tweaks">
      <TweakSection label="Theme" />
      <TweakRadio
        label="Mode"
        value={tweaks.theme}
        onChange={v => setTweak('theme', v)}
        options={['midnight', 'dawn']}
      />
      <TweakRadio
        label="Accent"
        value={tweaks.accent}
        onChange={v => setTweak('accent', v)}
        options={['mint', 'amber', 'lavender']}
      />
      <TweakSection label="Frame" />
      <TweakToggle
        label="iPhone bezel"
        value={tweaks.showFrame}
        onChange={v => setTweak('showFrame', v)}
      />
    </TweaksPanel>
  );
}

window.SnorvyTweaks = SnorvyTweaks;
window.SNORVY_DEFAULTS = SNORVY_DEFAULTS;

// Snorvy — modern interactive prototype
// Three tabs: Tonight, History, Settings. Recording state animates a live waveform.

const { useState, useEffect, useMemo, useRef } = React;

// ─────────────────────────────────────────────────────────────
// Theme tokens
// ─────────────────────────────────────────────────────────────
function useTheme(t) {
  const dark = t.theme === 'midnight';
  const accents = {
    mint:     { primary: 'oklch(0.84 0.14 175)', soft: 'oklch(0.84 0.14 175 / 0.16)', deep: 'oklch(0.55 0.10 175)' },
    amber:    { primary: 'oklch(0.84 0.14 75)',  soft: 'oklch(0.84 0.14 75 / 0.16)',  deep: 'oklch(0.55 0.10 75)'  },
    lavender: { primary: 'oklch(0.78 0.12 295)', soft: 'oklch(0.78 0.12 295 / 0.18)', deep: 'oklch(0.55 0.10 295)' },
  };
  const a = accents[t.accent] || accents.mint;
  return dark ? {
    dark: true,
    bg: '#0A0D17', bg2: '#0E1220',
    surface: 'rgba(255,255,255,0.04)',
    surfaceHi: 'rgba(255,255,255,0.06)',
    border: 'rgba(255,255,255,0.08)',
    borderHi: 'rgba(255,255,255,0.14)',
    text: '#ECEDF3',
    textDim: 'rgba(236,237,243,0.62)',
    textFaint: 'rgba(236,237,243,0.38)',
    accent: a.primary, accentSoft: a.soft, accentDeep: a.deep,
    talk: 'oklch(0.84 0.14 75)', talkSoft: 'oklch(0.84 0.14 75 / 0.16)',
  } : {
    dark: false,
    bg: '#F4F1EA', bg2: '#EDE8DD',
    surface: '#FFFFFF',
    surfaceHi: '#FAF7F0',
    border: 'rgba(20,16,10,0.08)',
    borderHi: 'rgba(20,16,10,0.16)',
    text: '#16130E',
    textDim: 'rgba(22,19,14,0.62)',
    textFaint: 'rgba(22,19,14,0.40)',
    accent: a.deep, accentSoft: a.soft, accentDeep: a.deep,
    talk: 'oklch(0.55 0.10 75)', talkSoft: 'oklch(0.84 0.14 75 / 0.18)',
  };
}

// ─────────────────────────────────────────────────────────────
// Display fonts
// ─────────────────────────────────────────────────────────────
const FONT_DISPLAY = '"Instrument Serif", "Times New Roman", serif';
const FONT_UI = '"Geist", -apple-system, system-ui, sans-serif';
const FONT_MONO = '"Geist Mono", ui-monospace, monospace';

// ─────────────────────────────────────────────────────────────
// Inline icons (stroke-based, 1.6px)
// ─────────────────────────────────────────────────────────────
const Icon = {
  moon: (c, s = 20) => <svg width={s} height={s} viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="1.6" strokeLinecap="round" strokeLinejoin="round"><path d="M21 12.8A9 9 0 1 1 11.2 3a7 7 0 0 0 9.8 9.8z"/></svg>,
  chart: (c, s = 20) => <svg width={s} height={s} viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="1.6" strokeLinecap="round" strokeLinejoin="round"><path d="M3 17l5-6 4 4 7-9"/><path d="M14 6h5v5"/></svg>,
  sliders: (c, s = 20) => <svg width={s} height={s} viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="1.6" strokeLinecap="round" strokeLinejoin="round"><path d="M4 6h10M18 6h2M4 12h2M10 12h10M4 18h14M20 18h0"/><circle cx="16" cy="6" r="2"/><circle cx="8" cy="12" r="2"/><circle cx="18" cy="18" r="2"/></svg>,
  mic: (c, s = 18) => <svg width={s} height={s} viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="1.6" strokeLinecap="round" strokeLinejoin="round"><rect x="9" y="3" width="6" height="12" rx="3"/><path d="M5 11a7 7 0 0 0 14 0M12 18v3"/></svg>,
  lock: (c, s = 16) => <svg width={s} height={s} viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="1.6" strokeLinecap="round" strokeLinejoin="round"><rect x="4" y="11" width="16" height="10" rx="2"/><path d="M8 11V7a4 4 0 0 1 8 0v4"/></svg>,
  bed: (c, s = 18) => <svg width={s} height={s} viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="1.6" strokeLinecap="round" strokeLinejoin="round"><path d="M3 18v-7a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2v7M3 14h18M3 21v-3M21 21v-3"/><circle cx="8" cy="11.5" r="1.5"/></svg>,
  phone: (c, s = 18) => <svg width={s} height={s} viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="1.6" strokeLinecap="round" strokeLinejoin="round"><rect x="6" y="3" width="12" height="18" rx="2"/><path d="M11 18h2"/></svg>,
  trash: (c, s = 18) => <svg width={s} height={s} viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="1.6" strokeLinecap="round" strokeLinejoin="round"><path d="M3 6h18M8 6V4a1 1 0 0 1 1-1h6a1 1 0 0 1 1 1v2M5 6l1 14a2 2 0 0 0 2 2h8a2 2 0 0 0 2-2l1-14"/></svg>,
  trashClock: (c, s = 18) => <svg width={s} height={s} viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="1.6" strokeLinecap="round" strokeLinejoin="round"><path d="M3 6h12M9 6V4a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v2M5 6l1 9.5"/><circle cx="16" cy="16" r="5"/><path d="M16 13.5V16l1.5 1.5"/></svg>,
  arrow: (c, s = 16) => <svg width={s} height={s} viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="1.6" strokeLinecap="round" strokeLinejoin="round"><path d="M9 6l6 6-6 6"/></svg>,
  badge: (c, s = 18) => <svg width={s} height={s} viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="1.6" strokeLinecap="round" strokeLinejoin="round"><circle cx="12" cy="10" r="6"/><path d="M9 14l-2 7 5-3 5 3-2-7"/></svg>,
  pen: (c, s = 18) => <svg width={s} height={s} viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="1.6" strokeLinecap="round" strokeLinejoin="round"><path d="M14 4l6 6L8 22H2v-6L14 4z"/></svg>,
  user: (c, s = 16) => <svg width={s} height={s} viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="1.6" strokeLinecap="round" strokeLinejoin="round"><circle cx="12" cy="8" r="4"/><path d="M4 21a8 8 0 0 1 16 0"/></svg>,
  wave: (c, s = 16) => <svg width={s} height={s} viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="1.8" strokeLinecap="round"><path d="M3 12h2M7 8v8M11 5v14M15 8v8M19 12h2"/></svg>,
  stop: (c, s = 18) => <svg width={s} height={s} viewBox="0 0 24 24" fill={c}><rect x="6" y="6" width="12" height="12" rx="2"/></svg>,
  play: (c, s = 14) => <svg width={s} height={s} viewBox="0 0 24 24" fill={c}><path d="M7 4l13 8-13 8V4z"/></svg>,
  plus: (c, s = 16) => <svg width={s} height={s} viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="1.8" strokeLinecap="round"><path d="M12 5v14M5 12h14"/></svg>,
};

// ─────────────────────────────────────────────────────────────
// Live waveform (animated bars)
// ─────────────────────────────────────────────────────────────
function Waveform({ active, color, dim, height = 56, count = 48 }) {
  const seed = useMemo(() => Array.from({ length: count }, (_, i) => 0.25 + 0.75 * Math.abs(Math.sin(i * 1.7) * Math.cos(i * 0.41))), [count]);
  const [t, setT] = useState(0);
  useEffect(() => {
    if (!active) return;
    let raf, start = performance.now();
    const tick = () => { setT((performance.now() - start) / 1000); raf = requestAnimationFrame(tick); };
    raf = requestAnimationFrame(tick);
    return () => cancelAnimationFrame(raf);
  }, [active]);

  return (
    <svg width="100%" height={height} viewBox={`0 0 ${count * 4} ${height}`} preserveAspectRatio="none" style={{ display: 'block' }}>
      {seed.map((s, i) => {
        const phase = active ? Math.abs(Math.sin(t * 2.4 + i * 0.32)) * 0.7 + 0.3 : 1;
        const h = active ? Math.max(2, s * height * phase * 0.9) : Math.max(2, s * height * 0.45);
        const y = (height - h) / 2;
        return <rect key={i} x={i * 4 + 1} y={y} width="2" height={h} rx="1" fill={active ? color : dim} />;
      })}
    </svg>
  );
}

// ─────────────────────────────────────────────────────────────
// Static event waveform (for past events)
// ─────────────────────────────────────────────────────────────
function StaticWave({ color, count = 22, height = 22, intensity = 0.6 }) {
  const bars = useMemo(() =>
    Array.from({ length: count }, (_, i) =>
      0.3 + 0.7 * Math.abs(Math.sin(i * (1 + intensity)) * Math.cos(i * 0.4))
    ),
  [count, intensity]);
  return (
    <svg width={count * 3} height={height} viewBox={`0 0 ${count * 3} ${height}`}>
      {bars.map((s, i) => {
        const h = Math.max(2, s * height);
        return <rect key={i} x={i * 3} y={(height - h) / 2} width="1.5" height={h} rx="0.75" fill={color} />;
      })}
    </svg>
  );
}

// ─────────────────────────────────────────────────────────────
// Sparkline for "last 7 nights"
// ─────────────────────────────────────────────────────────────
function Sparkline({ values, color, height = 36 }) {
  const w = 220, h = height;
  const max = Math.max(...values, 1);
  const pts = values.map((v, i) => [i * (w / (values.length - 1)), h - (v / max) * (h - 4) - 2]);
  const d = pts.map((p, i) => `${i === 0 ? 'M' : 'L'} ${p[0].toFixed(1)} ${p[1].toFixed(1)}`).join(' ');
  const area = `${d} L ${w} ${h} L 0 ${h} Z`;
  return (
    <svg width="100%" height={h} viewBox={`0 0 ${w} ${h}`} preserveAspectRatio="none">
      <defs>
        <linearGradient id="sparkfill" x1="0" x2="0" y1="0" y2="1">
          <stop offset="0%" stopColor={color} stopOpacity="0.35" />
          <stop offset="100%" stopColor={color} stopOpacity="0" />
        </linearGradient>
      </defs>
      <path d={area} fill="url(#sparkfill)" />
      <path d={d} fill="none" stroke={color} strokeWidth="1.6" strokeLinecap="round" strokeLinejoin="round" />
      {pts.map((p, i) => (
        <circle key={i} cx={p[0]} cy={p[1]} r={i === pts.length - 1 ? 3 : 1.5} fill={color} />
      ))}
    </svg>
  );
}

// ─────────────────────────────────────────────────────────────
// Bottom Tab Bar — glassy
// ─────────────────────────────────────────────────────────────
function TabBar({ tab, setTab, T }) {
  const items = [
    { id: 'tonight', label: 'Tonight', icon: Icon.moon },
    { id: 'history', label: 'History', icon: Icon.chart },
    { id: 'settings', label: 'Settings', icon: Icon.sliders },
  ];
  return (
    <div style={{
      position: 'absolute', left: 12, right: 12, bottom: 14, zIndex: 40,
      background: T.dark ? 'rgba(14,18,32,0.72)' : 'rgba(255,255,255,0.78)',
      backdropFilter: 'blur(20px) saturate(180%)',
      WebkitBackdropFilter: 'blur(20px) saturate(180%)',
      border: `1px solid ${T.border}`, borderRadius: 28,
      padding: 6,
      boxShadow: T.dark ? '0 8px 32px rgba(0,0,0,0.4)' : '0 8px 32px rgba(20,16,10,0.08)',
      display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 4,
    }}>
      {items.map(it => {
        const active = tab === it.id;
        return (
          <button key={it.id} onClick={() => setTab(it.id)} style={{
            appearance: 'none', border: 'none', background: 'transparent',
            padding: '10px 4px', borderRadius: 22, cursor: 'pointer',
            display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 4,
            color: active ? T.text : T.textDim,
            fontFamily: FONT_UI, fontSize: 11, fontWeight: 500, letterSpacing: 0.1,
            position: 'relative',
          }}>
            {active && (
              <span style={{
                position: 'absolute', inset: 0, borderRadius: 22,
                background: T.accentSoft,
              }}/>
            )}
            <span style={{ position: 'relative', zIndex: 1, color: active ? T.accent : T.textDim }}>
              {it.icon(active ? T.accent : T.textDim, 22)}
            </span>
            <span style={{ position: 'relative', zIndex: 1 }}>{it.label}</span>
          </button>
        );
      })}
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// Tonight Screen
// ─────────────────────────────────────────────────────────────
function TonightScreen({ T, recState, setRecState, filter, setFilter, events }) {
  const recording = recState.active;
  const dur = recState.duration;

  const filtered = events.filter(e => filter === 'all' || e.kind === filter);

  const fmt = (s) => {
    const m = Math.floor(s / 60), sec = s % 60;
    const h = Math.floor(m / 60);
    if (h > 0) return `${h}:${String(m % 60).padStart(2, '0')}:${String(sec).padStart(2, '0')}`;
    return `${String(m).padStart(2, '0')}:${String(sec).padStart(2, '0')}`;
  };

  return (
    <div style={{ padding: '0 20px 120px', position: 'relative' }}>
      {/* Header */}
      <div style={{ display: 'flex', alignItems: 'flex-start', justifyContent: 'space-between', paddingTop: 8, marginBottom: 22 }}>
        <div>
          <div style={{ fontFamily: FONT_MONO, fontSize: 11, letterSpacing: 1.4, color: T.textFaint, textTransform: 'uppercase', marginBottom: 4 }}>
            Tue · 7 May
          </div>
          <h1 style={{
            margin: 0, fontFamily: FONT_DISPLAY, fontSize: 56, lineHeight: 0.95, fontWeight: 400, color: T.text,
            letterSpacing: -1.2,
          }}>
            Tonight<span style={{ fontStyle: 'italic', color: T.accent }}>.</span>
          </h1>
          <div style={{ fontFamily: FONT_UI, fontSize: 14, color: T.textDim, marginTop: 8, maxWidth: 280, lineHeight: 1.4 }}>
            Records locally. Playback stays unlocked.
          </div>
        </div>
        <button style={{
          appearance: 'none', border: `1px solid ${T.border}`, background: T.surface,
          color: T.accent, fontFamily: FONT_UI, fontSize: 13, fontWeight: 500,
          padding: '8px 12px', borderRadius: 999, display: 'flex', alignItems: 'center', gap: 6,
          cursor: 'pointer',
        }}>
          {Icon.lock(T.accent, 14)} $9.99
        </button>
      </div>

      {/* Hero recording card */}
      <div style={{
        position: 'relative', borderRadius: 28,
        background: recording
          ? `linear-gradient(180deg, ${T.accentSoft}, ${T.surface})`
          : T.surface,
        border: `1px solid ${recording ? T.borderHi : T.border}`,
        padding: 22, overflow: 'hidden',
        boxShadow: T.dark ? '0 1px 0 rgba(255,255,255,0.04) inset' : '0 1px 0 rgba(255,255,255,0.6) inset',
      }}>
        {/* glow */}
        {recording && (
          <div style={{
            position: 'absolute', top: -80, right: -80, width: 220, height: 220, borderRadius: '50%',
            background: T.accent, filter: 'blur(80px)', opacity: 0.35, pointerEvents: 'none',
          }}/>
        )}

        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: 14, position: 'relative' }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
            <span style={{
              width: 8, height: 8, borderRadius: '50%',
              background: recording ? T.accent : T.textFaint,
              boxShadow: recording ? `0 0 0 4px ${T.accentSoft}` : 'none',
              animation: recording ? 'snorvy-pulse 1.6s ease-in-out infinite' : 'none',
            }}/>
            <span style={{ fontFamily: FONT_MONO, fontSize: 11, letterSpacing: 1.2, color: recording ? T.accent : T.textDim, textTransform: 'uppercase' }}>
              {recording ? 'Recording · local mic' : 'Ready for tonight'}
            </span>
          </div>
          <span style={{ fontFamily: FONT_MONO, fontSize: 13, color: T.text, fontVariantNumeric: 'tabular-nums', fontWeight: 500 }}>
            {fmt(dur)}
          </span>
        </div>

        <Waveform active={recording} color={T.accent} dim={T.borderHi} height={64} />

        <div style={{ marginTop: 16, display: 'flex', gap: 8, position: 'relative' }}>
          <button onClick={() => setRecState(s => ({ ...s, active: !s.active }))} style={{
            flex: 1, appearance: 'none', border: 'none', cursor: 'pointer',
            background: recording ? T.text : T.accent,
            color: recording ? T.bg : (T.dark ? '#0A0D17' : '#FFFFFF'),
            padding: '16px 20px', borderRadius: 18,
            fontFamily: FONT_UI, fontSize: 15, fontWeight: 600, letterSpacing: -0.1,
            display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 10,
            boxShadow: recording ? 'none' : `0 6px 20px ${T.accentSoft}`,
          }}>
            {recording ? Icon.stop(recording ? T.bg : '#fff', 16) : Icon.moon(T.dark ? '#0A0D17' : '#FFFFFF', 18)}
            {recording ? 'Stop & save' : 'Start local recording'}
          </button>
          <button style={{
            appearance: 'none', border: `1px solid ${T.border}`, cursor: 'pointer',
            background: 'transparent', color: T.text, padding: '0 18px', borderRadius: 18,
            fontFamily: FONT_UI, fontSize: 14, fontWeight: 500,
            display: 'flex', alignItems: 'center', gap: 6,
          }}>
            {Icon.sliders(T.text, 16)}
          </button>
        </div>
      </div>

      {/* Last 7 nights mini summary */}
      <div style={{ marginTop: 28, marginBottom: 16, display: 'flex', alignItems: 'baseline', justifyContent: 'space-between' }}>
        <h2 style={{ margin: 0, fontFamily: FONT_DISPLAY, fontSize: 28, fontWeight: 400, color: T.text, letterSpacing: -0.4 }}>
          Last night <span style={{ fontStyle: 'italic', color: T.textDim }}>timeline</span>
        </h2>
      </div>

      {/* Stat strip */}
      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', gap: 8, marginBottom: 18 }}>
        {[
          { k: 'Snore', v: '12', sub: 'events', color: T.accent },
          { k: 'Talk', v: '3', sub: 'clips', color: T.talk },
          { k: 'Quiet', v: '6h 42m', sub: 'rest', color: T.textDim },
        ].map((s, i) => (
          <div key={i} style={{
            background: T.surface, border: `1px solid ${T.border}`, borderRadius: 16,
            padding: '12px 12px 10px',
          }}>
            <div style={{ fontFamily: FONT_MONO, fontSize: 9.5, letterSpacing: 1.2, color: T.textFaint, textTransform: 'uppercase' }}>{s.k}</div>
            <div style={{ fontFamily: FONT_DISPLAY, fontSize: 26, fontWeight: 400, color: s.color, lineHeight: 1.1, marginTop: 2, letterSpacing: -0.6 }}>
              {s.v}
            </div>
            <div style={{ fontFamily: FONT_UI, fontSize: 11, color: T.textDim, marginTop: 1 }}>{s.sub}</div>
          </div>
        ))}
      </div>

      {/* Filter chips */}
      <div style={{ display: 'flex', gap: 6, marginBottom: 14 }}>
        {[
          { id: 'all', label: 'All', icon: null },
          { id: 'snore', label: 'Snore', icon: Icon.wave },
          { id: 'talk', label: 'Talk', icon: Icon.user },
        ].map(c => {
          const active = filter === c.id;
          return (
            <button key={c.id} onClick={() => setFilter(c.id)} style={{
              appearance: 'none', cursor: 'pointer',
              padding: '8px 14px', borderRadius: 999,
              border: `1px solid ${active ? 'transparent' : T.border}`,
              background: active ? T.accentSoft : 'transparent',
              color: active ? T.accent : T.text,
              fontFamily: FONT_UI, fontSize: 13, fontWeight: 500,
              display: 'flex', alignItems: 'center', gap: 6,
            }}>
              {c.icon && c.icon(active ? T.accent : T.textDim, 14)}
              {c.label}
            </button>
          );
        })}
      </div>

      {/* Events */}
      {filtered.length === 0 ? (
        <div style={{
          background: T.surface, border: `1px dashed ${T.borderHi}`, borderRadius: 18,
          padding: 22, display: 'flex', alignItems: 'center', gap: 14,
        }}>
          <span style={{
            width: 36, height: 36, borderRadius: 10,
            background: T.accentSoft, display: 'flex', alignItems: 'center', justifyContent: 'center', flexShrink: 0,
          }}>
            {Icon.chart(T.accent, 18)}
          </span>
          <div>
            <div style={{ fontFamily: FONT_UI, fontSize: 14, fontWeight: 500, color: T.text }}>No saved audio events yet</div>
            <div style={{ fontFamily: FONT_UI, fontSize: 12.5, color: T.textDim, marginTop: 2 }}>
              Start recording tonight to populate the timeline.
            </div>
          </div>
        </div>
      ) : (
        <div style={{ display: 'flex', flexDirection: 'column', gap: 8 }}>
          {filtered.map((e, i) => (
            <EventRow key={i} e={e} T={T} />
          ))}
        </div>
      )}
    </div>
  );
}

function EventRow({ e, T }) {
  const isSnore = e.kind === 'snore';
  const c = isSnore ? T.accent : T.talk;
  const cs = isSnore ? T.accentSoft : T.talkSoft;
  return (
    <div style={{
      background: T.surface, border: `1px solid ${T.border}`, borderRadius: 16,
      padding: '12px 14px', display: 'flex', alignItems: 'center', gap: 12,
    }}>
      <button style={{
        width: 36, height: 36, borderRadius: 12, flexShrink: 0,
        background: cs, border: 'none', cursor: 'pointer',
        display: 'flex', alignItems: 'center', justifyContent: 'center',
      }}>
        {Icon.play(c, 12)}
      </button>
      <div style={{ flex: 1, minWidth: 0 }}>
        <div style={{ display: 'flex', alignItems: 'baseline', gap: 8, marginBottom: 4 }}>
          <span style={{ fontFamily: FONT_MONO, fontSize: 11, color: T.textDim, fontVariantNumeric: 'tabular-nums' }}>{e.time}</span>
          <span style={{ fontFamily: FONT_UI, fontSize: 12.5, color: c, fontWeight: 500, textTransform: 'capitalize' }}>{e.kind}</span>
          <span style={{ fontFamily: FONT_UI, fontSize: 11, color: T.textFaint, marginLeft: 'auto' }}>{e.length}</span>
        </div>
        <StaticWave color={c} count={28} height={18} intensity={isSnore ? 0.7 : 0.4} />
      </div>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// History Screen
// ─────────────────────────────────────────────────────────────
function HistoryScreen({ T, hasData, setHasData }) {
  const days = useMemo(() => {
    if (!hasData) return Array.from({ length: 30 }, () => ({ filled: false, intensity: 0 }));
    return Array.from({ length: 30 }, (_, i) => ({
      filled: Math.random() > 0.18,
      intensity: Math.random(),
    }));
  }, [hasData]);

  const sparkValues = useMemo(() => [3, 5, 4, 7, 6, 9, 8], []);

  return (
    <div style={{ padding: '0 20px 120px' }}>
      <div style={{ paddingTop: 8, marginBottom: 22 }}>
        <div style={{ fontFamily: FONT_MONO, fontSize: 11, letterSpacing: 1.4, color: T.textFaint, textTransform: 'uppercase', marginBottom: 4 }}>
          30-night window
        </div>
        <h1 style={{
          margin: 0, fontFamily: FONT_DISPLAY, fontSize: 56, lineHeight: 0.95, fontWeight: 400, color: T.text,
          letterSpacing: -1.2,
        }}>
          History<span style={{ fontStyle: 'italic', color: T.accent }}>.</span>
        </h1>
        <div style={{ fontFamily: FONT_UI, fontSize: 14, color: T.textDim, marginTop: 8, maxWidth: 290, lineHeight: 1.4 }}>
          Local-only history is the v1 storage target. Older nights age off automatically.
        </div>
      </div>

      {!hasData ? (
        <>
          <div style={{
            background: T.surface, border: `1px dashed ${T.borderHi}`, borderRadius: 22,
            padding: '24px 20px', textAlign: 'center', marginBottom: 16,
          }}>
            <div style={{
              width: 48, height: 48, borderRadius: 14, margin: '0 auto 12px',
              background: T.accentSoft, display: 'flex', alignItems: 'center', justifyContent: 'center',
            }}>
              {Icon.bed(T.accent, 22)}
            </div>
            <div style={{ fontFamily: FONT_DISPLAY, fontSize: 22, fontWeight: 400, color: T.text, letterSpacing: -0.3 }}>
              No nights saved <span style={{ fontStyle: 'italic', color: T.textDim }}>yet</span>
            </div>
            <div style={{ fontFamily: FONT_UI, fontSize: 13, color: T.textDim, marginTop: 6, maxWidth: 240, marginLeft: 'auto', marginRight: 'auto' }}>
              Record a night, or add a manual log to start your trend.
            </div>
            <div style={{ display: 'flex', gap: 8, justifyContent: 'center', marginTop: 16 }}>
              <button onClick={() => setHasData(true)} style={{
                appearance: 'none', border: 'none', cursor: 'pointer',
                background: T.accent, color: T.dark ? '#0A0D17' : '#fff',
                padding: '11px 18px', borderRadius: 14,
                fontFamily: FONT_UI, fontSize: 13, fontWeight: 600,
                display: 'flex', alignItems: 'center', gap: 6,
              }}>
                {Icon.plus(T.dark ? '#0A0D17' : '#fff', 14)} Add manual log
              </button>
              <button style={{
                appearance: 'none', border: `1px solid ${T.border}`, cursor: 'pointer',
                background: 'transparent', color: T.text,
                padding: '11px 18px', borderRadius: 14,
                fontFamily: FONT_UI, fontSize: 13, fontWeight: 500,
              }}>
                Open recorder
              </button>
            </div>
          </div>

          {/* Hint pattern */}
          <div style={{
            background: T.surface, border: `1px solid ${T.border}`, borderRadius: 22, padding: 18,
          }}>
            <div style={{ display: 'flex', alignItems: 'baseline', justifyContent: 'space-between', marginBottom: 14 }}>
              <span style={{ fontFamily: FONT_MONO, fontSize: 10, letterSpacing: 1.2, color: T.textFaint, textTransform: 'uppercase' }}>
                Preview · sample shape
              </span>
              <span style={{ fontFamily: FONT_UI, fontSize: 11, color: T.textFaint }}>your data will land here</span>
            </div>
            <div style={{ display: 'grid', gridTemplateColumns: 'repeat(10, 1fr)', gap: 5 }}>
              {Array.from({ length: 30 }).map((_, i) => (
                <div key={i} style={{
                  aspectRatio: '1', borderRadius: 6,
                  background: T.borderHi, opacity: 0.4,
                }}/>
              ))}
            </div>
          </div>
        </>
      ) : (
        <>
          {/* Trend card */}
          <div style={{
            background: T.surface, border: `1px solid ${T.border}`, borderRadius: 22, padding: 20, marginBottom: 12,
          }}>
            <div style={{ display: 'flex', alignItems: 'baseline', justifyContent: 'space-between', marginBottom: 10 }}>
              <div>
                <div style={{ fontFamily: FONT_MONO, fontSize: 10, letterSpacing: 1.2, color: T.textFaint, textTransform: 'uppercase' }}>
                  7-night snore avg
                </div>
                <div style={{ fontFamily: FONT_DISPLAY, fontSize: 44, fontWeight: 400, color: T.text, letterSpacing: -1, lineHeight: 1, marginTop: 4 }}>
                  6<span style={{ fontStyle: 'italic', color: T.textDim, fontSize: 28 }}> events</span>
                </div>
              </div>
              <div style={{
                fontFamily: FONT_UI, fontSize: 11, fontWeight: 600,
                color: T.accent, background: T.accentSoft,
                padding: '4px 8px', borderRadius: 8,
              }}>↘ 22%</div>
            </div>
            <Sparkline values={sparkValues} color={T.accent} height={42} />
          </div>

          {/* Calendar grid */}
          <div style={{
            background: T.surface, border: `1px solid ${T.border}`, borderRadius: 22, padding: 18, marginBottom: 12,
          }}>
            <div style={{ display: 'flex', alignItems: 'baseline', justifyContent: 'space-between', marginBottom: 14 }}>
              <span style={{ fontFamily: FONT_MONO, fontSize: 10, letterSpacing: 1.2, color: T.textFaint, textTransform: 'uppercase' }}>
                30 nights
              </span>
              <span style={{ fontFamily: FONT_UI, fontSize: 11, color: T.textFaint }}>tap a tile</span>
            </div>
            <div style={{ display: 'grid', gridTemplateColumns: 'repeat(10, 1fr)', gap: 5 }}>
              {days.map((d, i) => (
                <div key={i} style={{
                  aspectRatio: '1', borderRadius: 6,
                  background: d.filled ? `oklch(${0.85 - d.intensity * 0.35} 0.14 175)` : T.borderHi,
                  opacity: d.filled ? 0.85 + d.intensity * 0.15 : 0.4,
                }}/>
              ))}
            </div>
          </div>

          {/* Recent night list */}
          <div style={{ display: 'flex', flexDirection: 'column', gap: 8 }}>
            {[
              { date: 'Mon · 6 May', dur: '7h 18m', snore: 4, talk: 1 },
              { date: 'Sun · 5 May', dur: '6h 42m', snore: 9, talk: 0 },
              { date: 'Sat · 4 May', dur: '8h 03m', snore: 6, talk: 2 },
            ].map((n, i) => (
              <div key={i} style={{
                background: T.surface, border: `1px solid ${T.border}`, borderRadius: 16,
                padding: '14px 16px', display: 'flex', alignItems: 'center', gap: 14,
              }}>
                <div style={{ flex: 1 }}>
                  <div style={{ fontFamily: FONT_MONO, fontSize: 10.5, color: T.textFaint, letterSpacing: 0.6, textTransform: 'uppercase' }}>{n.date}</div>
                  <div style={{ fontFamily: FONT_DISPLAY, fontSize: 22, color: T.text, fontWeight: 400, marginTop: 2, letterSpacing: -0.3 }}>{n.dur}</div>
                </div>
                <div style={{ display: 'flex', gap: 6 }}>
                  <span style={{ fontFamily: FONT_UI, fontSize: 11, color: T.accent, background: T.accentSoft, padding: '4px 8px', borderRadius: 8 }}>{n.snore} snore</span>
                  <span style={{ fontFamily: FONT_UI, fontSize: 11, color: T.talk, background: T.talkSoft, padding: '4px 8px', borderRadius: 8 }}>{n.talk} talk</span>
                </div>
                {Icon.arrow(T.textFaint, 14)}
              </div>
            ))}
          </div>
        </>
      )}
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// Settings Screen
// ─────────────────────────────────────────────────────────────
function Toggle({ on, onChange, T }) {
  return (
    <button onClick={() => onChange(!on)} style={{
      appearance: 'none', border: 'none', cursor: 'pointer',
      width: 46, height: 28, borderRadius: 999, padding: 3,
      background: on ? T.accent : (T.dark ? 'rgba(255,255,255,0.12)' : 'rgba(20,16,10,0.18)'),
      transition: 'background 0.2s ease',
      display: 'flex', alignItems: 'center',
    }}>
      <span style={{
        width: 22, height: 22, borderRadius: '50%',
        background: '#fff', boxShadow: '0 1px 3px rgba(0,0,0,0.2)',
        transform: on ? 'translateX(18px)' : 'translateX(0)',
        transition: 'transform 0.22s cubic-bezier(0.3, 0.8, 0.4, 1)',
      }}/>
    </button>
  );
}

function SettingsScreen({ T, settings, setSettings }) {
  return (
    <div style={{ padding: '0 20px 120px' }}>
      <div style={{ paddingTop: 8, marginBottom: 22 }}>
        <div style={{ fontFamily: FONT_MONO, fontSize: 11, letterSpacing: 1.4, color: T.textFaint, textTransform: 'uppercase', marginBottom: 4 }}>
          Preferences
        </div>
        <h1 style={{
          margin: 0, fontFamily: FONT_DISPLAY, fontSize: 56, lineHeight: 0.95, fontWeight: 400, color: T.text,
          letterSpacing: -1.2,
        }}>
          Settings<span style={{ fontStyle: 'italic', color: T.accent }}>.</span>
        </h1>
        <div style={{ fontFamily: FONT_UI, fontSize: 14, color: T.textDim, marginTop: 8, maxWidth: 290, lineHeight: 1.4 }}>
          Privacy and purchase defaults are wired to the product promise.
        </div>
      </div>

      {/* Privacy group */}
      <div style={{
        background: T.surface, border: `1px solid ${T.border}`, borderRadius: 22,
        padding: 4, marginBottom: 14,
      }}>
        <SettingRow T={T} icon={Icon.phone} title="Local-only audio" sub="No cloud sync in Snorvy v1.">
          <Toggle on={settings.local} onChange={v => setSettings(s => ({ ...s, local: v }))} T={T} />
        </SettingRow>
        <Divider T={T} />
        <SettingRow T={T} icon={Icon.trashClock} title="Auto-delete talk clips" sub="Default privacy window is 30 days.">
          <Toggle on={settings.autoDelete} onChange={v => setSettings(s => ({ ...s, autoDelete: v }))} T={T} />
        </SettingRow>
        <Divider T={T} />
        <SettingRow T={T} icon={Icon.trash} title="Delete local sleep data" sub="Remove history and recordings from this phone." chevron danger />
      </div>

      {/* Paywall card */}
      <div style={{
        position: 'relative', overflow: 'hidden',
        background: `linear-gradient(135deg, ${T.accentSoft}, ${T.surface})`,
        border: `1px solid ${T.borderHi}`, borderRadius: 22, padding: 20, marginBottom: 14,
      }}>
        <div style={{
          position: 'absolute', top: -40, right: -40, width: 140, height: 140, borderRadius: '50%',
          background: T.accent, filter: 'blur(60px)', opacity: 0.2, pointerEvents: 'none',
        }}/>
        <div style={{ display: 'flex', alignItems: 'center', gap: 12, marginBottom: 14, position: 'relative' }}>
          <span style={{
            width: 40, height: 40, borderRadius: 12, background: T.accent,
            display: 'flex', alignItems: 'center', justifyContent: 'center',
          }}>
            {Icon.badge(T.dark ? '#0A0D17' : '#fff', 20)}
          </span>
          <div>
            <div style={{ fontFamily: FONT_MONO, fontSize: 10.5, letterSpacing: 1.2, color: T.textDim, textTransform: 'uppercase' }}>Free trial</div>
            <div style={{ fontFamily: FONT_DISPLAY, fontSize: 28, color: T.text, fontWeight: 400, letterSpacing: -0.5, lineHeight: 1.05 }}>
              0 of 7 <span style={{ fontStyle: 'italic', color: T.textDim }}>nights used</span>
            </div>
          </div>
        </div>

        {/* progress */}
        <div style={{ height: 4, borderRadius: 2, background: T.border, overflow: 'hidden', marginBottom: 16, position: 'relative' }}>
          <div style={{ height: '100%', width: '0%', background: T.accent }}/>
        </div>

        <div style={{ fontFamily: FONT_UI, fontSize: 13, color: T.textDim, marginBottom: 14, position: 'relative', lineHeight: 1.45 }}>
          $9.99 <span style={{ color: T.text, fontWeight: 500 }}>once</span> unlocks unlimited nights, full history, and exports. No subscription.
        </div>

        <button style={{
          width: '100%', appearance: 'none', border: 'none', cursor: 'pointer',
          background: T.text, color: T.bg,
          padding: '14px 18px', borderRadius: 16,
          fontFamily: FONT_UI, fontSize: 14, fontWeight: 600,
          display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 8, position: 'relative',
        }}>
          {Icon.lock(T.bg, 14)} Unlock Snorvy · $9.99
        </button>
      </div>

      {/* Manual log */}
      <button style={{
        width: '100%', appearance: 'none', cursor: 'pointer',
        background: T.surface, border: `1px solid ${T.border}`,
        padding: '14px 18px', borderRadius: 16, marginBottom: 14,
        fontFamily: FONT_UI, fontSize: 14, fontWeight: 500, color: T.accent,
        display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 8,
      }}>
        {Icon.pen(T.accent, 16)} Add manual sleep log
      </button>

      {/* About */}
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', padding: '0 6px' }}>
        <span style={{ fontFamily: FONT_MONO, fontSize: 10.5, color: T.textFaint, letterSpacing: 1 }}>SNORVY · v1.0.0</span>
        <span style={{ fontFamily: FONT_MONO, fontSize: 10.5, color: T.textFaint, letterSpacing: 1 }}>Made for sleep, not for clouds.</span>
      </div>
    </div>
  );
}

function Divider({ T }) {
  return <div style={{ height: 1, background: T.border, marginLeft: 56 }}/>;
}

function SettingRow({ T, icon, title, sub, children, chevron, danger }) {
  return (
    <div style={{
      padding: '14px 14px', display: 'flex', alignItems: 'center', gap: 14,
      cursor: chevron ? 'pointer' : 'default',
    }}>
      <span style={{
        width: 36, height: 36, borderRadius: 11, flexShrink: 0,
        background: T.surfaceHi, border: `1px solid ${T.border}`,
        display: 'flex', alignItems: 'center', justifyContent: 'center',
      }}>
        {icon(danger ? (T.dark ? '#FF8A8A' : '#C24A4A') : T.text, 18)}
      </span>
      <div style={{ flex: 1, minWidth: 0 }}>
        <div style={{ fontFamily: FONT_UI, fontSize: 14.5, fontWeight: 500, color: danger ? (T.dark ? '#FF8A8A' : '#C24A4A') : T.text, letterSpacing: -0.1 }}>{title}</div>
        <div style={{ fontFamily: FONT_UI, fontSize: 12.5, color: T.textDim, marginTop: 2, lineHeight: 1.35 }}>{sub}</div>
      </div>
      {children}
      {chevron && Icon.arrow(T.textFaint, 14)}
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// Root App
// ─────────────────────────────────────────────────────────────
function SnorvyApp({ tweaks }) {
  const T = useTheme(tweaks);
  const [tab, setTab] = useState('tonight');
  const [recState, setRecState] = useState({ active: false, duration: 0 });
  const [filter, setFilter] = useState('all');
  const [hasHistory, setHasHistory] = useState(true);
  const [settings, setSettings] = useState({ local: true, autoDelete: true });

  // recording timer
  useEffect(() => {
    if (!recState.active) return;
    const id = setInterval(() => setRecState(s => ({ ...s, duration: s.duration + 1 })), 1000);
    return () => clearInterval(id);
  }, [recState.active]);

  // sample events appear after recording
  const events = useMemo(() => {
    if (recState.duration < 5) return [];
    return [
      { time: '01:14', kind: 'snore', length: '8s' },
      { time: '02:38', kind: 'talk',  length: '12s' },
      { time: '03:52', kind: 'snore', length: '14s' },
      { time: '05:11', kind: 'snore', length: '6s' },
    ];
  }, [recState.duration]);

  return (
    <div style={{
      width: '100%', height: '100%', background: T.bg, color: T.text,
      fontFamily: FONT_UI, position: 'relative', overflow: 'hidden',
      display: 'flex', flexDirection: 'column',
    }}>
      {/* ambient gradient */}
      {T.dark && (
        <div style={{
          position: 'absolute', top: 0, left: '50%', transform: 'translateX(-50%)',
          width: '120%', height: 360, pointerEvents: 'none',
          background: `radial-gradient(closest-side, ${T.accentSoft}, transparent 70%)`,
          opacity: 0.5,
        }}/>
      )}

      {/* status bar spacer */}
      <div style={{ height: 56 }} data-screen-label={
        tab === 'tonight' ? 'Tonight' : tab === 'history' ? 'History' : 'Settings'
      }/>

      <div style={{ flex: 1, overflow: 'auto', position: 'relative' }} data-screen-label="screen-scroll">
        {tab === 'tonight' && <TonightScreen T={T} recState={recState} setRecState={setRecState} filter={filter} setFilter={setFilter} events={events}/>}
        {tab === 'history' && <HistoryScreen T={T} hasData={hasHistory} setHasData={setHasHistory}/>}
        {tab === 'settings' && <SettingsScreen T={T} settings={settings} setSettings={setSettings}/>}
      </div>

      <TabBar tab={tab} setTab={setTab} T={T}/>
    </div>
  );
}

window.SnorvyApp = SnorvyApp;

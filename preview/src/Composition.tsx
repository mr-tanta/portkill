import {
  AbsoluteFill,
  Easing,
  interpolate,
  useCurrentFrame,
  useVideoConfig,
} from "remotion";

type TerminalLine = {
  at: number;
  text: string;
  tone: "command" | "success" | "muted" | "warning" | "json" | "process";
  typed?: boolean;
};

const terminalLines: TerminalLine[] = [
  { at: -10, text: "$ portkill list 3000", tone: "command", typed: true },
  { at: 42, text: "PID    NAME       PORT   STATE", tone: "muted" },
  { at: 50, text: "8421   node       3000   LISTEN", tone: "process" },
  { at: 74, text: "$ portkill --dry-run 3000", tone: "command", typed: true },
  { at: 103, text: "[dry-run] would terminate PID 8421 (node)", tone: "warning" },
  { at: 128, text: "$ portkill --docker list 8080", tone: "command", typed: true },
  { at: 158, text: "api-web  0.0.0.0:8080->80/tcp  container", tone: "process" },
  { at: 184, text: "$ portkill --json list 4567", tone: "command", typed: true },
  { at: 211, text: '{"port":4567,"processes":[],"safe":true}', tone: "json" },
];

const highlights = [
  { at: 40, label: "Exact port matching", value: "3000 != 30000" },
  { at: 96, label: "Dry-run safety", value: "Preview before kill" },
  { at: 150, label: "Docker aware", value: "Processes + containers" },
  { at: 206, label: "Automation ready", value: "JSON output" },
];

const toneColor = {
  command: "#f7fafc",
  success: "#55e6a5",
  muted: "#7f8ea3",
  warning: "#ffd166",
  json: "#93c5fd",
  process: "#8ce99a",
} satisfies Record<TerminalLine["tone"], string>;

const clamp01 = (value: number) => Math.max(0, Math.min(1, value));

const typedText = (line: TerminalLine, frame: number, fps: number) => {
  if (!line.typed) {
    return line.text;
  }

  const characters = Math.floor(
    interpolate(frame, [line.at, line.at + 0.9 * fps], [0, line.text.length], {
      easing: Easing.bezier(0.16, 1, 0.3, 1),
      extrapolateLeft: "clamp",
      extrapolateRight: "clamp",
    }),
  );

  return line.text.slice(0, characters);
};

const TerminalLineView: React.FC<{
  line: TerminalLine;
  frame: number;
  fps: number;
}> = ({ line, frame, fps }) => {
  const enter = interpolate(frame, [line.at, line.at + 10], [0, 1], {
    easing: Easing.bezier(0.16, 1, 0.3, 1),
    extrapolateLeft: "clamp",
    extrapolateRight: "clamp",
  });
  const text = typedText(line, frame, fps);
  const showCursor =
    Boolean(line.typed) && frame >= line.at && frame < line.at + 0.95 * fps;

  return (
    <div
      style={{
        minHeight: 34,
        display: "flex",
        alignItems: "center",
        color: toneColor[line.tone],
        fontFamily:
          'ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", monospace',
        fontSize: line.tone === "json" ? 25 : 27,
        letterSpacing: 0,
        opacity: enter,
        transform: `translateY(${interpolate(enter, [0, 1], [10, 0])}px)`,
        whiteSpace: "pre",
      }}
    >
      {text}
      {showCursor ? <span style={{ color: "#55e6a5" }}>_</span> : null}
    </div>
  );
};

const HighlightCard: React.FC<{
  label: string;
  value: string;
  active: boolean;
  index: number;
}> = ({ label, value, active, index }) => {
  const frame = useCurrentFrame();
  const intro = interpolate(frame, [24 + index * 8, 42 + index * 8], [0, 1], {
    easing: Easing.bezier(0.16, 1, 0.3, 1),
    extrapolateLeft: "clamp",
    extrapolateRight: "clamp",
  });

  return (
    <div
      style={{
        border: `1px solid ${active ? "#55e6a5" : "#223044"}`,
        background: active ? "rgba(85, 230, 165, 0.11)" : "rgba(15, 23, 42, 0.82)",
        borderRadius: 8,
        padding: "18px 20px",
        opacity: intro,
        transform: `translateX(${interpolate(intro, [0, 1], [24, 0])}px)`,
        boxShadow: active ? "0 0 0 1px rgba(85, 230, 165, 0.2)" : "none",
      }}
    >
      <div
        style={{
          color: active ? "#b8ffd9" : "#d8e3ef",
          fontFamily: "Inter, Arial, sans-serif",
          fontWeight: 700,
          fontSize: 25,
          letterSpacing: 0,
          marginBottom: 8,
        }}
      >
        {label}
      </div>
      <div
        style={{
          color: active ? "#55e6a5" : "#8ba1ba",
          fontFamily: "Inter, Arial, sans-serif",
          fontSize: 20,
          letterSpacing: 0,
        }}
      >
        {value}
      </div>
    </div>
  );
};

export const PortKillPreview: React.FC = () => {
  const frame = useCurrentFrame();
  const { fps } = useVideoConfig();

  const intro = interpolate(frame, [0, 30], [0.82, 1], {
    easing: Easing.bezier(0.16, 1, 0.3, 1),
    extrapolateLeft: "clamp",
    extrapolateRight: "clamp",
  });
  const pulse = 0.5 + 0.5 * Math.sin((frame / fps) * Math.PI * 2);
  const visibleLines = terminalLines.filter((line) => frame >= line.at).slice(-7);
  const activeHighlight = highlights.reduce((latest, item, index) => {
    return frame >= item.at ? index : latest;
  }, 0);

  return (
    <AbsoluteFill
      style={{
        background:
          "radial-gradient(circle at 18% 12%, rgba(85, 230, 165, 0.16), transparent 28%), linear-gradient(135deg, #071018 0%, #101827 54%, #15111d 100%)",
        color: "#f8fafc",
        fontFamily: "Inter, Arial, sans-serif",
        padding: 54,
      }}
    >
      <div
        style={{
          display: "flex",
          justifyContent: "space-between",
          alignItems: "flex-start",
          opacity: intro,
          transform: `translateY(${interpolate(intro, [0, 1], [18, 0])}px)`,
        }}
      >
        <div>
          <div
            style={{
              color: "#55e6a5",
              fontSize: 22,
              fontWeight: 800,
              letterSpacing: 0,
              textTransform: "uppercase",
            }}
          >
            PortKill
          </div>
          <div
            style={{
              marginTop: 8,
              fontSize: 48,
              fontWeight: 800,
              letterSpacing: 0,
              lineHeight: 1.05,
              maxWidth: 690,
            }}
          >
            Find and clear local port conflicts fast.
          </div>
        </div>
        <div
          style={{
            border: "1px solid rgba(147, 197, 253, 0.38)",
            color: "#bfdbfe",
            borderRadius: 999,
            padding: "12px 18px",
            fontSize: 18,
            fontWeight: 700,
            letterSpacing: 0,
            background: "rgba(14, 30, 48, 0.72)",
          }}
        >
          macOS + Linux
        </div>
      </div>

      <div
        style={{
          display: "grid",
          gridTemplateColumns: "1.58fr 0.92fr",
          gap: 30,
          marginTop: 36,
        }}
      >
        <div
          style={{
            border: "1px solid #263449",
            background: "rgba(5, 10, 18, 0.88)",
            borderRadius: 8,
            overflow: "hidden",
            boxShadow: "0 28px 80px rgba(0, 0, 0, 0.38)",
            opacity: intro,
            transform: `scale(${interpolate(intro, [0, 1], [0.98, 1])})`,
          }}
        >
          <div
            style={{
              height: 48,
              background: "#111827",
              borderBottom: "1px solid #263449",
              display: "flex",
              alignItems: "center",
              gap: 9,
              padding: "0 18px",
            }}
          >
            {["#ff5f57", "#ffbd2e", "#28c840"].map((color) => (
              <span
                key={color}
                style={{
                  width: 13,
                  height: 13,
                  borderRadius: 999,
                  background: color,
                  display: "inline-block",
                }}
              />
            ))}
            <span
              style={{
                marginLeft: 14,
                color: "#8ba1ba",
                fontFamily:
                  'ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", monospace',
                fontSize: 17,
              }}
            >
              terminal - portkill
            </span>
          </div>
          <div style={{ padding: "28px 30px 34px", minHeight: 378 }}>
            {visibleLines.map((line) => (
              <TerminalLineView
                key={`${line.at}-${line.text}`}
                line={line}
                frame={frame}
                fps={fps}
              />
            ))}
          </div>
        </div>

        <div style={{ display: "grid", gap: 16 }}>
          {highlights.map((item, index) => (
            <HighlightCard
              key={item.label}
              label={item.label}
              value={item.value}
              index={index}
              active={index === activeHighlight}
            />
          ))}
        </div>
      </div>

      <div
        style={{
          position: "absolute",
          left: 54,
          right: 54,
          bottom: 34,
          height: 5,
          borderRadius: 999,
          background: "rgba(39, 52, 71, 0.95)",
          overflow: "hidden",
        }}
      >
        <div
          style={{
            width: `${clamp01(frame / 238) * 100}%`,
            height: "100%",
            background: `linear-gradient(90deg, #55e6a5, rgba(147, 197, 253, ${
              0.65 + pulse * 0.35
            }))`,
          }}
        />
      </div>
    </AbsoluteFill>
  );
};

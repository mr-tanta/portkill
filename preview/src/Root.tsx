import "./index.css";
import { Composition } from "remotion";
import { PortKillPreview } from "./Composition";

export const RemotionRoot: React.FC = () => {
  return (
    <>
      <Composition
        id="PortKillPreview"
        component={PortKillPreview}
        durationInFrames={240}
        fps={30}
        width={1280}
        height={720}
      />
    </>
  );
};

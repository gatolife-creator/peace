import { CSSProperties } from "react";

type Props = {
  children: JSX.Element[] | string;
  style?: CSSProperties;
};

export const CustomContainer = ({ children, style }: Props) => {
  return (
    <div
      style={{
        width: "80%",
        backgroundColor: "white",
        margin: "0 auto",
        marginTop: "20px",
        border: "1px solid lightgray",
        borderRadius: "20px",
        boxShadow: "0px 10px 15px rgba(0, 0, 0, 0.1)",
        ...style,
      }}
    >
      {children}
    </div>
  );
};

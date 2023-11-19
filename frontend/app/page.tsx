"use client";

import { useRouter } from "next/navigation";

const Home = () => {
  const router = useRouter();

  const handleClick = () => {
    router.push("/login");
    router.refresh();
  };

  return (
    <main>
      <h1>InkHub</h1>
      <button onClick={handleClick}>Get Started</button>
    </main>
  );
};

export default Home;

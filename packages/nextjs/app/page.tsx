"use client";

import Image from "next/image";
// import Link from "next/link";
import type { NextPage } from "next";
// import { useAccount } from "wagmi";
// import { BugAntIcon, MagnifyingGlassIcon } from "@heroicons/react/24/outline";
// import { Address } from "~~/components/scaffold-eth";
import { useScaffoldContractRead } from "~~/hooks/scaffold-eth";

const Home: NextPage = () => {
  // const { address: connectedAddress } = useAccount();
  const { data: productImageUrl } = useScaffoldContractRead({
    contractName: "Product",
    functionName: "productImageUrl",
  });
  const { data: StoreName } = useScaffoldContractRead({
    contractName: "Product",
    functionName: "StoreName",
  });
  const { data: productName } = useScaffoldContractRead({
    contractName: "Product",
    functionName: "productName",
  });
  const { data: pricePerOne } = useScaffoldContractRead({
    contractName: "Product",
    functionName: "pricePerOne",
  });
  const { data: totalAvailableStoke } = useScaffoldContractRead({
    contractName: "Product",
    functionName: "totalAvailableStoke",
  });
  return (
    <>
      <div className="border w-[100px] h-[350px] bg-primary">
        <p>{StoreName}</p>
        <p>{productName}</p>
        <div className="relative w-24 h-40 overflow-hidden">
          <Image src={productImageUrl ?? "/iphone.png"} alt="Iphone Image" fill className="objects-fit" />
        </div>
        <div>
          <p>{pricePerOne}</p>
          <p>{totalAvailableStoke}</p>
        </div>
      </div>
    </>
  );
};

export default Home;

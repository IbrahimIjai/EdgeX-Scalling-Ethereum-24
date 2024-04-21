"use client";

import Image from "next/image";
import { ArrowBigDown, ArrowBigUp, MessageCircle } from "lucide-react";
// import Link from "next/link";
import type { NextPage } from "next";
import { formatEther } from "viem";
import { useAccount } from "wagmi";
// import { BugAntIcon, MagnifyingGlassIcon } from "@heroicons/react/24/outline";
// import { Address } from "~~/components/scaffold-eth";
import { useScaffoldContractRead } from "~~/hooks/scaffold-eth";

const Home: NextPage = () => {
  const { address: connectedAddress } = useAccount();
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
  const { data: customerVote } = useScaffoldContractRead({
    contractName: "Product",
    functionName: "customerVote",
    args: [connectedAddress ?? ""],
  });

  const { data: upVotes } = useScaffoldContractRead({
    contractName: "Product",
    functionName: "upVotes",
  });
  const { data: downVotes } = useScaffoldContractRead({
    contractName: "Product",
    functionName: "downVotes",
  });

  // customerVote

  const formattedPricePerOne = pricePerOne ? formatEther(pricePerOne) : 0;
  const formatedTotalAvailableStock = totalAvailableStoke ? Number(totalAvailableStoke) : 0;

  return (
    <>
      <div className="border w-[290px] bg-primary flex flex-col rounded-lg p-6">
        <div>
          <p className="text-lg font-bold">{StoreName} Store</p>
        </div>
        <div className="text-xs">Ticker: {productName}</div>
        <div className="relative w-[240px] h-[200px] my-1 overflow-hidden">
          <Image src={productImageUrl ?? "/iphone.png"} alt="Iphone Image" fill className="objects-fit" />
        </div>
        <div className="text-xs">
          <div className="flex items-center gap-1">
            <p className="font-bold">Price:</p>
            <p className=""> {formattedPricePerOne} ETH</p>
          </div>
          <div className="flex items-center gap-1">
            <p className="font-bold">Goods Available:</p>
            <p>{formatedTotalAvailableStock} Units</p>
          </div>
        </div>
        <div className="flex items-center justify-between w-full">
          <div className="flex flex-col items-center gap-1">
            <div>
              <ArrowBigUp
                className={`h-5 w-5 text-zinc-700 cursor-pointer ${
                  customerVote === 1 ? "text-primary fill-secondary scale-105" : ""
                }`}
              />
              <span>{upVotes ? Number(upVotes) : ""}</span>
            </div>
            <span className="text-xs">vote</span>
            <div>
              <ArrowBigDown
                className={`h-5 w-5 text-zinc-700 cursor-pointer ${
                  customerVote === 2 ? "text-primary fill-secondary scale-105" : ""
                }`}
              />
              <span>{downVotes ? Number(downVotes) : ""}</span>
            </div>
          </div>
          <div>
            <MessageCircle className="w-5 h-5 cursor-pointer" />
          </div>
        </div>
      </div>
    </>
  );
};

export default Home;

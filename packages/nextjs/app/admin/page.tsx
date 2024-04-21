"use client";

import { useEffect, useState } from "react";
// import Link from "next/link";
import type { NextPage } from "next";
import { InputBase } from "~~/components/scaffold-eth";
// import { BugAntIcon, MagnifyingGlassIcon } from "@heroicons/react/24/outline";
// import { Address } from "~~/components/scaffold-eth";
import { useScaffoldContractRead, useScaffoldContractWrite } from "~~/hooks/scaffold-eth";

const Home: NextPage = () => {
  // const { address: connectedAddress } = useAccount();
  const [trxIndex, setTrxIndex] = useState("");
  const [userAddress, setUserAddress] = useState("");

  const { data: buyerAddress, isSuccess: BuyerAddressSuccess } = useScaffoldContractRead({
    contractName: "Product",
    functionName: "buyerByTransactionIndex",
    args: [BigInt(trxIndex)],
  });

  const { writeAsync: completeDelivery, isLoading: isDeliveryLoading } = useScaffoldContractWrite({
    contractName: "Product",
    functionName: "deliveredCompleted",
    args: [BigInt(trxIndex), userAddress],
  });

  useEffect(() => {
    BuyerAddressSuccess && buyerAddress && setUserAddress(buyerAddress);
  }, []);

  return (
    <>
      <div className="flex items-center justify-center w-full min-h-screen">
        <InputBase value={trxIndex} onChange={value => setTrxIndex(value)} />
        {isDeliveryLoading && <p>Is Loading...</p>}
        <button className="btn-secondary" onClick={() => completeDelivery()}>
          Mark Delivered
        </button>
      </div>
    </>
  );
};

export default Home;

import { EvmChains, IndexService, SignProtocolClient, SpMode } from "@ethsign/sp-sdk";
import { ClassValue, clsx } from "clsx";
import { twMerge } from "tailwind-merge";

export * from "./fetchPriceFromUniswap";
export * from "./networks";
export * from "./notification";
export * from "./block";
export * from "./decodeTxData";
export * from "./getParsedError";

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}

export const ethSignClient = new SignProtocolClient(SpMode.OnChain, {
  chain: EvmChains.arbitrumSepolia,
});

export const ethSignIndexServiceClient = new IndexService("testnet");

export function jsonToBytes(jsonData: any): Uint8Array {
  const dataString = JSON.stringify(jsonData);

  // Use TextEncoder to encode the string as UTF-8 bytes
  const encoder = new TextEncoder();
  return encoder.encode(dataString);
}

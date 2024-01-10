import React, { useState, useEffect, useContext } from 'react';
import { useRouter } from 'next/router';

// INTERNAL IMPORTS

import {
  checkIfWalletConnected,
  connectWallet,
  connectingWithContract,
} from '../Utils/apiFeature';

// Create a context
export const ChatAppContext = React.createContext();

// Context provider component
export const ChatAppProvider = ({ children }) => {
  // Router instance from Next.js
  const router = useRouter();

  // State to manage wallet connection status
  const [isWalletConnected, setIsWalletConnected] = useState(false);

  // State to store the connected wallet address
  const [walletAddress, setWalletAddress] = useState('');

  // State to store the contract instance
  const [contract, setContract] = useState(null);

  // Effect to check if wallet is connected on component mount
  useEffect(() => {
    const checkConnection = async () => {
      const isConnected = await checkIfWalletConnected();
      setIsWalletConnected(isConnected);
    };

    checkConnection();
  }, []);

  // Function to connect the wallet
  const handleConnectWallet = async () => {
    try {
      const address = await connectWallet();
      setWalletAddress(address);
      setIsWalletConnected(true);
      router.push('/dashboard'); // Redirect to dashboard or another page after successful connection
    } catch (error) {
      console.error('Error connecting wallet:', error.message);
    }
  };

  // Function to connect with the contract
  const handleConnectWithContract = async () => {
    try {
      const contractInstance = await connectingWithContract();
      setContract(contractInstance);
      // Do any additional setup or logic with the contract instance if needed
    } catch (error) {
      console.error('Error connecting with contract:', error.message);
    }
  };

  // Context value containing state and functions
  const contextValue = {
    title: "Hey, welcome to decentralized blockchain chat app",
    isWalletConnected,
    walletAddress,
    contract,
    connectWallet: handleConnectWallet,
    connectWithContract: handleConnectWithContract,
  };

  // Provide the context value to the children components
  return (
    <ChatAppContext.Provider value={contextValue}>
      {children}
    </ChatAppContext.Provider>
  );
};

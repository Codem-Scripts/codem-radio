import React, { useState, useEffect } from 'react';
import { motion } from "framer-motion";
import { MainContext, ClientMessage } from './Context';

import './App.scss'

import Radio from './components/Radio';

const App = () => {

  // General
  const [isOpen, setOpen] = useState(false);

  const [isRadioID, setRadioID] = useState([])
  const [isPlayerID, setPlayerID] = useState(0)

  const [isRadioClick, setRadioClick] = useState(true);
  const [isSettingsClick, setSettingsClick] = useState(false);

  const [isVolume, setVolume] = useState(0);
  const [isRadio, setRadio] = useState([]);

  const [isLanguage, setLanguage] = useState([])

  const [isPosition, setPosition] = useState({ x: 2000, y: 900  });
  const [isPositionStatus, setPositionStatus] = useState(false);

  
  useEffect(() => {
    const SendNUIMessage = (event) => {
      const { action, data } = event.data;
      if (action === 'setOpen') {
        setOpen(data.OpenClose)
        setPlayerID(data.PlayerID)
        setLanguage(data.Language)
      } else if (action === 'setPlayerID') {
        setRadioID(data)
      } else if (action === 'setPosation') {
        setPositionStatus(prevState => !prevState)
      } else if (action === 'setRadioReset') {
        setPosition({ x: 1765, y: 850 });
      }
    }

    const SendNUIKeydown = (event) => {
      if (event.keyCode === 27 && isOpen === true) {
        ClientMessage("Close")
      }
    }
    
    window.addEventListener("message", SendNUIMessage);
    window.addEventListener('keydown', SendNUIKeydown);
    return () => {
      window.removeEventListener("message", SendNUIMessage);
      window.removeEventListener('keydown', SendNUIKeydown);
    }
  }, [isOpen]);

  return (
    <motion.div
      className="radio"
      animate={isOpen ? { opacity: 1, zIndex: 5, scale: 1 } : { opacity: 0, zIndex: 0 }}
      initial={{ opacity: 0, scale: 0.7 }}
      transition={{ duration: 0.8 }}
      style={{
        left: `${isPosition.x - 70}px`,
        top: `${isPosition.y - 398}px`, 
      }}>
      <MainContext.Provider
        value={{
          isOpen, setOpen,
          isVolume, setVolume,
          isRadioClick, setRadioClick,
          isSettingsClick, setSettingsClick,
          isPlayerID, setPlayerID,
          isRadio, setRadio,
          isRadioID, setRadioID,
          isLanguage, setLanguage,
          isPositionStatus, setPositionStatus,
          isPosition, setPosition
          
        }}>
        <Radio />
      </MainContext.Provider>
    </motion.div>
  );
}

export default App;

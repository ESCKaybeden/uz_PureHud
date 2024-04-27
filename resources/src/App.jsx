import React, {useState, useEffect} from 'react';
import { motion } from "framer-motion";
import { MainContext, useContext } from './Context';
import { Hook } from './hook/Hook';

import PlayersHud from './components/PlayerHud';
import Status from './components/Status';
import Speedometer from './components/Speedometer';

import './App.scss'

const App = () => {
  const { Visible, StreetDisplay } = useContext(MainContext);

  return (
    <motion.div className="UZStore" animate={Visible.is ? { opacity: 1, zIndex:5 } : { opacity: 0, zIndex:0 } }>
      <Status/>
      {StreetDisplay && (<Location/>)}
      <PlayersHud/>
      <Speedometer/>
    </motion.div>
  );
}

export const Location = () => {
  const { UIColor, Speedometer, AlwaysOnMinimap, Street } = useContext(MainContext);
  return (
    <motion.div className="Location" animate={(Speedometer.Visible || AlwaysOnMinimap) ? {bottom: '16.8rem'} : {bottom: '5rem'}}>
      <div className="Street1"><p style={{color: UIColor.is['Location']}}>{Street.Street1}</p></div>
      <div className="Street2"><p style={{color: `${UIColor.is['Location']}80`}} id='2'>{Street.Street2}</p></div>
      {Hook.GetSVG('LocationSVG', UIColor.is['Location'])}
    </motion.div>
  )
}

export default App;
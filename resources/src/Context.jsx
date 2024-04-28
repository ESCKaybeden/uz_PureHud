import {createContext, useContext, useState, useEffect} from "react";
import App from "./App";

const MainContext = createContext()

const Provider = () => {
    const [isVisible, setVisible] = useState(false);
    const [isSpeedometerVisible, setSpeedometerVisible] = useState(false);
    
    const [isMoney, setMoney] = useState('230.000.000');
    const [isServerName, setServerName] = useState('uz rp');
    const [isID, setID] = useState('6');
    const [isOnline, setOnline] = useState('300');
    
    const [isHealth, setHealth] = useState(50);
    const [isArmor, setArmor] = useState(100);
    const [isHunger, setHunger] = useState(100);
    const [isThirst, setThirst] = useState(100);
    const [isOxygen, setOxygen] = useState(100);
    const [isStress, setStress] = useState(50);
    
    const [isUIColor, setUIColor] = useState({
      Health: '#F3163E',
      Armour: '#00A3FF',
      Hunger: '#ADFE00',
      Thirst: '#00FFF0',
      Stamina: '#FFA048',
      Stress: '#FF0099',
      
      Location: '#FFFFFF',
      MoneyBackground: '#FFFFFF',
      ServersBackground: '#FFFFFF',
      ServerDetails: '#F3163E',
      MoneyIcon: '#F3163E',
    });


    const [isSpeed, setSpeed] = useState(320);
    const [isRpm, setRpm] = useState(700);
    const [isGear, setGear] = useState(0);
    const [isFuel, setFuel] = useState(0);
    const [isEngine, setEngine] = useState(false);
    const [isSeatbelt, setSeatbelt] = useState(false);
    const [isLight, setLight] = useState(false);
    const [isEngineDamage, setEngineDamage] = useState(0);
    
    const [isAlwaysOnMinimap, setAlwaysOnMinimap] = useState(false);
    const [isSpeedType, setSpeedType] = useState('mph');
    const [isMoneyType, setMoneyType] = useState('$');

    const [isStreetDisplay, setStreetDisplay] = useState(true);

    const [isStreet, setStreet] = useState({
      Street1: 'DOWNTOWN ST.',
      Street2: 'DOWNTOWN ST.',
    });

    useEffect(() => {
        const SendNUIMessage = (event) => {
          const { action, data } = event.data;
          if (action === 'setOpen') {
            setVisible(data.setOpen)
          } else if (action === 'setHealth') {
            setHealth(data)
          } else if (action === 'setArmour') {
            setArmor(data)
          } else if (action === 'setStamina') {
            setOxygen(data)
          } else if (action === 'setUpdateNeeds') {
            setHunger(data.Hunger)
            setThirst(data.Thirst)
          } else if (action === 'setUpdateNeedsHunger') {
            setHunger(data)
          } else if (action === 'setUpdateNeedsThirst') {
            setThirst(data)
          } else if (action === 'setSpedometer') {
            setSpeedometerVisible(data)
            if (!data) {
              setSpeed(320)
              setRpm(700)
              setFuel(0)
            }
          } else if (action === 'Speed') {
            setSpeed(data.Speed)
            setRpm(Math.ceil(data.Rpm * 630))
            setGear(data.Gear)
            setFuel(data.Fuel)
            setEngineDamage(data.EngineDamage)
            setEngine(data.Engine)
            setSeatbelt(data.Seatbelt)
            setLight(data.Light)
          } else if (action === 'setFirstSetUp') {
            setID(data.ID)
            setServerName(data.ServerName)
            setAlwaysOnMinimap(data.AlwaysOnMinimap)
            setSpeedType(data.SpeedType)
            setMoneyType(data.MoneyType)
            setStreetDisplay(data.StreetDisplay)

            setUIColor(data.UIColor)

            setVisible(data.setVisible)
          } else if (action === 'setMoney') {
            setMoney(data)
          } else if (action === 'setPlayersUpdate') {
            setOnline(data)
          } else if (action === 'setStreet') {
            setStreet({
              Street1: data.Street1,
              Street2: data.Street2,
            })
          } else if (action === 'setUpdateStress') {
            setStress(data)
          }
        }
        window.addEventListener("message", SendNUIMessage);
      return () => {
        window.removeEventListener("message", SendNUIMessage);
      }
    });




    return (
      <MainContext.Provider
        value={{
          Visible: {is: isVisible, set: setVisible},
          UIColor: {is: isUIColor, set: setUIColor},
          Status: {
            Health: isHealth,
            Armour: isArmor,
            Hunger: isHunger,
            Thirst: isThirst,
            Stamina: isOxygen,
            Stress: isStress,
          },
          PlayerHud: {
            Money: isMoney,
            ServerName: isServerName,
            ID: isID,
            Online: isOnline,
            MoneyType: isMoneyType,
          },
          Speedometer: {
            Visible: isSpeedometerVisible,
            Speed: isSpeed,
            Rpm: isRpm,
            Gear: isGear,
            SpeedType: isSpeedType,
            Fuel: isFuel,
            EngineDamage: isEngineDamage,
            Engine: isEngine,
            Seatbelt: isSeatbelt,
            Light: isLight,
          },
          AlwaysOnMinimap: isAlwaysOnMinimap,
          StreetDisplay: isStreetDisplay,
          Street: isStreet,
        }}
      >
      <App />
      </MainContext.Provider>
    );
  };

export {
  MainContext,
  useContext,
  Provider
}
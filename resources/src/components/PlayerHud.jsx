import React from 'react'
import { MainContext, useContext } from '../Context'
import { Hook } from '../hook/Hook';

export default function PlayersHud() {
    const { UIColor, PlayerHud } = useContext(MainContext);

    const Time = new Date()
    return (
        <div className='PlayerHud'>
            <div className="Servers" style={{background: `linear-gradient(269.86deg, ${UIColor.is['ServersBackground']}80 21.46%, ${UIColor.is['ServersBackground']}00 93.27%)`}}>
                <div className="ServerName"><p style={{color: UIColor.is['ServerDetails'], textShadow: `-.125rem .125rem .313rem ${UIColor.is['ServerDetails']}4f`}}>{PlayerHud.ServerName}</p></div>
                <div className="Time"><p>{Time.getDate()}.{Time.getMonth() + 1}.{Time.getFullYear()}   /   {Time.getHours()}.{Time.getMinutes()}</p></div>
                <div className="ID"><p style={{color: UIColor.is['ServerDetails']}}>ID <span>{PlayerHud.ID}</span></p></div>
                <div className="Players">
                    <p>{PlayerHud.Online}</p>
                    {Hook.GetSVG('OnlineSVG', UIColor.is['ServerDetails'])}
                </div>
            </div>

            <div className="Money" style={{background: `linear-gradient(269.86deg, ${UIColor.is['MoneyBackground']}80 21.46%, ${UIColor.is['MoneyBackground']}00 93.27%)`}}>
                <p>{PlayerHud.MoneyType}{PlayerHud.Money}</p>
                {Hook.GetSVG('MoneySVG', UIColor.is['MoneyIcon'])}
            </div>
            
        </div>
    )
}


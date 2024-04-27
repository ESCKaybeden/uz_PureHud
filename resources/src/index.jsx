import React from 'react'
import ReactDOM from 'react-dom'
import { Provider } from "./Context";

ReactDOM.render(
  <React.StrictMode>
    <Provider />
  </React.StrictMode>,
  document.getElementById('root')
)

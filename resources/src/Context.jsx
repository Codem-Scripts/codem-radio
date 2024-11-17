import { createContext, useContext } from "react";
const MainContext = createContext()

const ClientMessage = (msg, send, iscb, callback) => {
    new Promise(function () {
        const https = new XMLHttpRequest();
        https.open("POST", `https://codem-radio/` + msg);
        https.send(send);
        if (iscb) {
            https.onload = function() {
                if (this.status >= 200 && this.status < 400) {
                  callback(https.response)
                }
            };
        }
    });
  }


export {
    MainContext,
    useContext,
    ClientMessage
}
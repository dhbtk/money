import * as React from "react";
import * as ReactDOM from "react-dom";
import * as moment from "moment";
import {browserHistory, IndexRoute, Route, Router} from "react-router";
import Home from "./components/Home";
import Login from "./components/Login";
import {store} from "./store";
import {configureAuthentication, requireAuth} from "@edanniehues/devise-token-auth-redux";
import {Provider} from "react-redux";
import "moment/locale/pt-br";
import App from "./components/App";
import {pushError, pushNotice} from "./actions/flashActions";
import "../css/application.scss";

configureAuthentication({
    pushError,
    pushNotice,
    store
});

moment.locale('pt-br');

let myWindow = window as any;
myWindow.react = React;
myWindow.React = React;
myWindow.moment = moment;

document.addEventListener('DOMContentLoaded', () => {
    ReactDOM.render(
        <Provider store={store}>
            <Router history={browserHistory}>
                <Route path="/login" component={Login}/>
                <Route path="/" component={App}>
                    <IndexRoute component={Home} onEnter={requireAuth}/>
                </Route>
            </Router>
        </Provider>, document.getElementById('app'));
});

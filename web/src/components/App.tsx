import * as React from "react";
import {connect, Dispatch} from "react-redux";
import * as authActions from "@edanniehues/devise-token-auth-redux/actions";
import {browserHistory, Link} from "react-router";
import FlashAlert from "./common/FlashAlert";
import {IState} from "../models";
import Component = React.Component;

export interface IAppProps {
    loading: boolean,
    token: any,
    user: any,
    dispatch: Dispatch<IState>
}

export interface IAppState {
    isOpen: boolean
}

class App extends Component<IAppProps, IAppState> {
    constructor(props: IAppProps) {
        super(props);

        this.toggle = this.toggle.bind(this);
        this.state = {
            isOpen: false
        };
    }

    toggle() {
        this.setState({
            isOpen: !this.state.isOpen
        });
    }

    componentWillReceiveProps(nextProps: IAppProps) {
        if (nextProps.token.token == null) {
            browserHistory.push('/login');
        }
    }

    logOut(event: any) {
        event.preventDefault();
        this.props.dispatch(authActions.logout());
    }

    render() {
        if (!this.props.token.validated) {
            return this.props.children as JSX.Element;
        }
        return (
            <div>
                <div id="progress-bar" className={this.props.loading ? 'active' : ''}/>
                <button id="navigation-toggler" className="navbar-toggler" onClick={this.toggle}><span className="navbar-toggler-icon"/></button>
                <div id="navigation-container">
                    <nav id="navigation" className={this.state.isOpen ? 'open' : ''}>
                        Oi
                    </nav>
                    <main id="main">
                        {this.props.children}
                    </main>
                </div>
            </div>
        );
    }
}

export default connect(
    ({loading, token, user}: {loading: boolean, token: any, user: any}): any => {
        return {loading, token, user};
}, (dispatch: Dispatch<IState>): any => ({dispatch}))(App);


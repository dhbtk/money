import {Action} from "redux";
export const START_LOADING: string = 'START_LOADING';
export const STOP_LOADING: string = 'STOP_LOADING';

export const PUSH_NOTICE: string = 'PUSH_NOTICE';
export const POP_NOTICE: string = 'POP_NOTICE';
export const PUSH_ERROR: string = 'PUSH_ERROR';
export const POP_ERROR: string = 'POP_ERROR';

interface IAction<P> extends Action {
    type: string,
    payload: P
}

export default IAction;

export interface IApplicationRecord {
    id: number,
    created_at: string,
    updated_at: string
}



export interface IFlash {
    type: string,
    text: string
}

export interface IState {
    loading: boolean,

    flash: IFlash

    token: any,
    user: any
}

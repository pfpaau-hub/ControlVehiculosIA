import { api } from './client'

export interface LoginResponse {
  token: string
  expiry: string
  userName: string
  idEmpresa: number
  periodo: string
  idCaja: number
}

export const authApi = {
  login: (userName: string, password: string) =>
    api.post<LoginResponse>('/auth/login', { userName, password }).then((r) => r.data),

  me: () => api.get<LoginResponse>('/auth/me').then((r) => r.data),
}

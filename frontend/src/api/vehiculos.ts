import { api } from './client'

export interface Vehiculo {
  id: number
  numPlaca: string
  marca: string
  linea: string
  modelo: string
  color: string
  tipo: string
  motor: string
  nit: string           // FK a cliente
  fechaUltMov: string
}

export const vehiculosApi = {
  getAll: (nit?: string) =>
    api.get<Vehiculo[]>('/vehiculos', { params: { nit } }).then((r) => r.data),

  getById: (id: number) =>
    api.get<Vehiculo>(`/vehiculos/${id}`).then((r) => r.data),

  create: (data: Partial<Vehiculo>) =>
    api.post<Vehiculo>('/vehiculos', data).then((r) => r.data),

  update: (id: number, data: Partial<Vehiculo>) =>
    api.put<Vehiculo>(`/vehiculos/${id}`, data).then((r) => r.data),

  delete: (id: number) =>
    api.delete(`/vehiculos/${id}`),
}

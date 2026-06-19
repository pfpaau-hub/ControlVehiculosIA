import { api } from './client'

export interface OrdenServicio {
  id: number
  idOrden: number
  numPlaca: string
  facturarA: string
  nit: string
  fecha: string
  status: number        // 1=abierta, 2=cerrada
  observaciones: string
  encargado: string
  recibeOrden: string
  lecturaActual: number
  proximoServicio: number
  anticipo: number
  numero: number        // 0=sin factura
  detalles?: DetalleOS[]
}

export interface DetalleOS {
  id: number
  linea: number
  idServicio: string
  descripcion: string
  idEmpleado: string
  cantidad: number
  precio: number
  totalLinea: number
}

export const ordenesApi = {
  getAll: (status?: number) =>
    api.get<OrdenServicio[]>('/ordenes-servicio', { params: { status } }).then((r) => r.data),

  getById: (id: number) =>
    api.get<OrdenServicio>(`/ordenes-servicio/${id}`).then((r) => r.data),

  create: (data: Partial<OrdenServicio>) =>
    api.post<OrdenServicio>('/ordenes-servicio', data).then((r) => r.data),

  update: (id: number, data: Partial<OrdenServicio>) =>
    api.put<OrdenServicio>(`/ordenes-servicio/${id}`, data).then((r) => r.data),

  delete: (id: number) =>
    api.delete(`/ordenes-servicio/${id}`),

  cerrar: (id: number) =>
    api.post(`/ordenes-servicio/${id}/cerrar`).then((r) => r.data),

  reabrir: (id: number) =>
    api.post(`/ordenes-servicio/${id}/reabrir`).then((r) => r.data),
}

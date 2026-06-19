import { api } from './client'

export interface Presupuesto {
  id: number
  idOrden: number
  numPlaca: string
  facturarA: string
  nit: string
  fecha: string
  status: number        // 1=abierto, 2=cerrado
  observaciones: string
  detalles?: DetallePresupuesto[]
}

export interface DetallePresupuesto {
  id: number
  linea: number
  idServicio: string
  descripcion: string
  idEmpleado: string
  cantidad: number
  precio: number
  totalLinea: number
  autorizado: number
}

export const presupuestosApi = {
  getAll: (status?: number) =>
    api.get<Presupuesto[]>('/presupuestos', { params: { status } }).then((r) => r.data),

  getById: (id: number) =>
    api.get<Presupuesto>(`/presupuestos/${id}`).then((r) => r.data),

  create: (data: Partial<Presupuesto>) =>
    api.post<Presupuesto>('/presupuestos', data).then((r) => r.data),

  update: (id: number, data: Partial<Presupuesto>) =>
    api.put<Presupuesto>(`/presupuestos/${id}`, data).then((r) => r.data),

  delete: (id: number) =>
    api.delete(`/presupuestos/${id}`),

  convertir: (id: number) =>
    api.post<{ id: number; idOrden: number; mensaje: string }>(
      `/presupuestos/${id}/convertir`
    ).then((r) => r.data),
}

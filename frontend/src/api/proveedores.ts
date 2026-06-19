import { api } from './client'

export interface Proveedor {
  id: number
  nit: string
  nombre: string
  facturarA: string
  tarjeta: string
  tipo: string          // 'C'=cliente, 'P'=proveedor, 'A'=ambos
  telefono: string
  direccion: string
  diasCredito: number
  limiteCreditoCliente: number
}

export interface ProveedorNitLookup {
  id: number
  nit: string
  nombre: string
  facturarA: string
  tarjeta: string
  tipo: string
}

export const proveedoresApi = {
  getAll: (tipo?: 'C' | 'P' | 'A') =>
    api.get<Proveedor[]>('/proveedores', { params: { tipo } }).then((r) => r.data),

  getById: (id: number) =>
    api.get<Proveedor>(`/proveedores/${id}`).then((r) => r.data),

  create: (data: Partial<Proveedor>) =>
    api.post<Proveedor>('/proveedores', data).then((r) => r.data),

  update: (id: number, data: Partial<Proveedor>) =>
    api.put<Proveedor>(`/proveedores/${id}`, data).then((r) => r.data),

  delete: (id: number) =>
    api.delete(`/proveedores/${id}`),

  getByNit: (nit: string) =>
    api.get<ProveedorNitLookup>(`/proveedores/nit/${encodeURIComponent(nit)}`).then((r) => r.data),
}

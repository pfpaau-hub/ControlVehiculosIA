import { api } from './client'

export interface Producto {
  id: number
  idProducto: string
  descripcion: string
  esServicio: number    // 1=servicio, 0=producto
  precioa: number
  costoPromedio: number
  tipo: string
  estado: string
}

export const productosApi = {
  getAll: (esServicio?: number, q?: string) =>
    api.get<Producto[]>('/productos', { params: { esServicio, q } }).then((r) => r.data),

  getById: (id: number) =>
    api.get<Producto>(`/productos/${id}`).then((r) => r.data),

  create: (data: Partial<Producto>) =>
    api.post<Producto>('/productos', data).then((r) => r.data),

  update: (id: number, data: Partial<Producto>) =>
    api.put<Producto>(`/productos/${id}`, data).then((r) => r.data),

  delete: (id: number) =>
    api.delete(`/productos/${id}`),
}

import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom'
import RequireAuth from './components/RequireAuth'
import AppLayout from './components/AppLayout'
import LoginPage from './modules/auth/LoginPage'
import DashboardPage from './modules/dashboard/DashboardPage'
import OrdenesPage from './modules/ordenes/OrdenesPage'
import PresupuestosPage from './modules/presupuestos/PresupuestosPage'
import ClientesPage from './modules/clientes/ClientesPage'
import VehiculosPage from './modules/vehiculos/VehiculosPage'
import ProductosPage from './modules/productos/ProductosPage'

export default function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/login" element={<LoginPage />} />
        <Route element={<RequireAuth />}>
          <Route element={<AppLayout />}>
            <Route path="/" element={<Navigate to="/dashboard" replace />} />
            <Route path="/dashboard" element={<DashboardPage />} />
            <Route path="/ordenes" element={<OrdenesPage />} />
            <Route path="/presupuestos" element={<PresupuestosPage />} />
            <Route path="/clientes" element={<ClientesPage />} />
            <Route path="/vehiculos" element={<VehiculosPage />} />
            <Route path="/productos" element={<ProductosPage />} />
          </Route>
        </Route>
        <Route path="*" element={<Navigate to="/" replace />} />
      </Routes>
    </BrowserRouter>
  )
}

import { useState } from 'react'
import { Layout, Menu, Avatar, Dropdown, Tag, theme } from 'antd'
import {
  DashboardOutlined,
  FileTextOutlined,
  ToolOutlined,
  TeamOutlined,
  CarOutlined,
  ShoppingOutlined,
  LogoutOutlined,
  MenuFoldOutlined,
  MenuUnfoldOutlined,
  UserOutlined,
} from '@ant-design/icons'
import { Outlet, useNavigate, useLocation } from 'react-router-dom'
import { useAuthStore } from '../store/authStore'

const { Header, Sider, Content } = Layout

const menuItems = [
  { key: '/dashboard',     icon: <DashboardOutlined />,  label: 'Dashboard'    },
  { key: '/ordenes',       icon: <ToolOutlined />,        label: 'Órdenes de Servicio' },
  { key: '/presupuestos',  icon: <FileTextOutlined />,   label: 'Presupuestos' },
  { key: '/clientes',      icon: <TeamOutlined />,        label: 'Clientes'     },
  { key: '/vehiculos',     icon: <CarOutlined />,         label: 'Vehículos'    },
  { key: '/productos',     icon: <ShoppingOutlined />,    label: 'Productos'    },
]

export default function AppLayout() {
  const [collapsed, setCollapsed] = useState(false)
  const { user, logout } = useAuthStore()
  const navigate = useNavigate()
  const location = useLocation()
  const { token } = theme.useToken()

  const userMenu = {
    items: [
      {
        key: 'logout',
        icon: <LogoutOutlined />,
        label: 'Cerrar sesión',
        danger: true,
        onClick: () => { logout(); navigate('/login') },
      },
    ],
  }

  return (
    <Layout style={{ minHeight: '100vh' }}>
      <Sider
        collapsible
        collapsed={collapsed}
        onCollapse={setCollapsed}
        trigger={null}
        style={{ background: token.colorBgContainer }}
      >
        <div style={{
          height: 64,
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          borderBottom: `1px solid ${token.colorBorderSecondary}`,
          fontWeight: 700,
          fontSize: collapsed ? 14 : 16,
          color: token.colorPrimary,
          padding: '0 16px',
        }}>
          {collapsed ? 'CV' : 'Control Vehículos'}
        </div>
        <Menu
          mode="inline"
          selectedKeys={[location.pathname]}
          items={menuItems}
          onClick={({ key }) => navigate(key)}
          style={{ borderRight: 0, marginTop: 8 }}
        />
      </Sider>

      <Layout>
        <Header style={{
          background: token.colorBgContainer,
          borderBottom: `1px solid ${token.colorBorderSecondary}`,
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'space-between',
          padding: '0 24px',
        }}>
          <span
            style={{ cursor: 'pointer', fontSize: 18 }}
            onClick={() => setCollapsed(!collapsed)}
          >
            {collapsed ? <MenuUnfoldOutlined /> : <MenuFoldOutlined />}
          </span>

          <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
            {user && (
              <>
                <Tag color="blue">Empresa {user.idEmpresa}</Tag>
                <Tag color="green">Período {user.periodo}</Tag>
              </>
            )}
            <Dropdown menu={userMenu} placement="bottomRight">
              <Avatar
                style={{ cursor: 'pointer', background: token.colorPrimary }}
                icon={<UserOutlined />}
              />
            </Dropdown>
          </div>
        </Header>

        <Content style={{ margin: 24, minHeight: 280 }}>
          <Outlet />
        </Content>
      </Layout>
    </Layout>
  )
}

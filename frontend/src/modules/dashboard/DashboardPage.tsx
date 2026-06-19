import { Card, Col, Row, Statistic, Typography } from 'antd'
import {
  ToolOutlined,
  FileTextOutlined,
  CarOutlined,
  TeamOutlined,
} from '@ant-design/icons'
import { useNavigate } from 'react-router-dom'

const { Title, Text } = Typography

const accesos = [
  { icon: <ToolOutlined style={{ fontSize: 32, color: '#1677ff' }} />,
    title: 'Órdenes de Servicio', desc: 'Gestionar trabajos del taller', path: '/ordenes', color: '#e6f4ff' },
  { icon: <FileTextOutlined style={{ fontSize: 32, color: '#52c41a' }} />,
    title: 'Presupuestos', desc: 'Crear y convertir presupuestos', path: '/presupuestos', color: '#f6ffed' },
  { icon: <TeamOutlined style={{ fontSize: 32, color: '#fa8c16' }} />,
    title: 'Clientes', desc: 'Administrar clientes y proveedores', path: '/clientes', color: '#fff7e6' },
  { icon: <CarOutlined style={{ fontSize: 32, color: '#722ed1' }} />,
    title: 'Vehículos', desc: 'Historial de vehículos', path: '/vehiculos', color: '#f9f0ff' },
]

export default function DashboardPage() {
  const navigate = useNavigate()

  return (
    <div>
      <Title level={4} style={{ marginBottom: 24 }}>Panel Principal</Title>

      <Row gutter={[16, 16]}>
        {accesos.map((a) => (
          <Col xs={24} sm={12} lg={6} key={a.path}>
            <Card
              hoverable
              onClick={() => navigate(a.path)}
              style={{ textAlign: 'center', background: a.color, border: 'none' }}
              styles={{ body: { padding: '24px 16px' } }}
            >
              {a.icon}
              <div style={{ marginTop: 12 }}>
                <Statistic title={a.title} valueRender={() => (
                  <Text type="secondary" style={{ fontSize: 12 }}>{a.desc}</Text>
                )} />
              </div>
            </Card>
          </Col>
        ))}
      </Row>
    </div>
  )
}

import { useState } from 'react'
import { Form, Input, Button, Card, Typography, Alert } from 'antd'
import { UserOutlined, LockOutlined } from '@ant-design/icons'
import { useNavigate } from 'react-router-dom'
import { authApi } from '../../api/auth'
import { useAuthStore } from '../../store/authStore'

const { Title } = Typography

export default function LoginPage() {
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const { login } = useAuthStore()
  const navigate = useNavigate()

  const onFinish = async (values: { userName: string; password: string }) => {
    setLoading(true)
    setError(null)
    try {
      const data = await authApi.login(values.userName, values.password)
      login(data.token, {
        userName: data.userName,
        idEmpresa: data.idEmpresa,
        periodo: data.periodo,
        idCaja: data.idCaja,
      })
      navigate('/ordenes')
    } catch {
      setError('Usuario o contraseña incorrectos')
    } finally {
      setLoading(false)
    }
  }

  return (
    <div style={{
      minHeight: '100vh',
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center',
      background: '#f0f2f5',
    }}>
      <Card style={{ width: 360, boxShadow: '0 4px 12px rgba(0,0,0,0.1)' }}>
        <div style={{ textAlign: 'center', marginBottom: 32 }}>
          <Title level={3} style={{ marginBottom: 4 }}>Control Vehículos</Title>
          <Typography.Text type="secondary">Sistema de Gestión de Taller</Typography.Text>
        </div>

        {error && (
          <Alert message={error} type="error" showIcon style={{ marginBottom: 16 }} />
        )}

        <Form layout="vertical" onFinish={onFinish} autoComplete="off">
          <Form.Item
            name="userName"
            rules={[{ required: true, message: 'Ingrese su usuario' }]}
          >
            <Input prefix={<UserOutlined />} placeholder="Usuario" size="large" />
          </Form.Item>

          <Form.Item
            name="password"
            rules={[{ required: true, message: 'Ingrese su contraseña' }]}
          >
            <Input.Password prefix={<LockOutlined />} placeholder="Contraseña" size="large" />
          </Form.Item>

          <Form.Item style={{ marginBottom: 0 }}>
            <Button type="primary" htmlType="submit" block size="large" loading={loading}>
              Iniciar sesión
            </Button>
          </Form.Item>
        </Form>
      </Card>
    </div>
  )
}

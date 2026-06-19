import { useState } from 'react'
import {
  Table, Button, Tag, Space, Modal, Form, Input, InputNumber,
  message, Popconfirm, Card, Row, Col, Typography, Select, Segmented,
} from 'antd'
import { PlusOutlined, EditOutlined } from '@ant-design/icons'
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { proveedoresApi, type Proveedor } from '../../api/proveedores'

const { Title } = Typography

const tipoColor: Record<string, string> = { C: 'blue', P: 'green', A: 'purple' }
const tipoLabel: Record<string, string> = { C: 'Cliente', P: 'Proveedor', A: 'Ambos' }

export default function ClientesPage() {
  const qc = useQueryClient()
  const [form] = Form.useForm()
  const [open, setOpen] = useState(false)
  const [editId, setEditId] = useState<number | null>(null)
  const [tipoFilter, setTipoFilter] = useState<'C' | 'P' | 'A' | undefined>('C')

  const { data = [], isLoading } = useQuery({
    queryKey: ['proveedores', tipoFilter],
    queryFn: () => proveedoresApi.getAll(tipoFilter),
  })

  const save = useMutation({
    mutationFn: (values: Partial<Proveedor>) =>
      editId ? proveedoresApi.update(editId, values) : proveedoresApi.create(values),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['proveedores'] })
      message.success('Guardado correctamente')
      setOpen(false); form.resetFields(); setEditId(null)
    },
    onError: () => message.error('Error al guardar'),
  })

  const eliminar = useMutation({
    mutationFn: proveedoresApi.delete,
    onSuccess: () => { qc.invalidateQueries({ queryKey: ['proveedores'] }); message.success('Eliminado') },
  })

  const openEdit = (rec: Proveedor) => {
    setEditId(rec.id); form.setFieldsValue(rec); setOpen(true)
  }

  const columns = [
    { title: 'NIT', dataIndex: 'nit', width: 120 },
    { title: 'Nombre', dataIndex: 'nombre', ellipsis: true },
    { title: 'Tipo', dataIndex: 'tipo', width: 90,
      render: (t: string) => <Tag color={tipoColor[t]}>{tipoLabel[t]}</Tag> },
    { title: 'Teléfono', dataIndex: 'telefono', width: 120 },
    { title: 'Días crédito', dataIndex: 'diasCredito', width: 100 },
    {
      title: 'Acciones', key: 'a', width: 100,
      render: (_: any, rec: Proveedor) => (
        <Space size={4}>
          <Button size="small" icon={<EditOutlined />} onClick={() => openEdit(rec)} />
          <Popconfirm title="¿Eliminar?" onConfirm={() => eliminar.mutate(rec.id)}>
            <Button size="small" danger>×</Button>
          </Popconfirm>
        </Space>
      ),
    },
  ]

  return (
    <div>
      <Card style={{ marginBottom: 16 }}>
        <Row justify="space-between" align="middle">
          <Col><Title level={4} style={{ margin: 0 }}>Clientes / Proveedores</Title></Col>
          <Col>
            <Space>
              <Segmented
                options={[
                  { label: 'Clientes', value: 'C' },
                  { label: 'Proveedores', value: 'P' },
                  { label: 'Todos', value: undefined as any },
                ]}
                value={tipoFilter}
                onChange={(v) => setTipoFilter(v as any)}
              />
              <Button type="primary" icon={<PlusOutlined />}
                onClick={() => { setEditId(null); form.resetFields(); setOpen(true) }}>
                Nuevo
              </Button>
            </Space>
          </Col>
        </Row>
      </Card>

      <Table rowKey="id" columns={columns} dataSource={data}
        loading={isLoading} size="small" pagination={{ pageSize: 20 }} />

      <Modal
        title={editId ? 'Editar' : 'Nuevo Cliente / Proveedor'}
        open={open}
        onCancel={() => { setOpen(false); form.resetFields() }}
        onOk={() => form.submit()}
        confirmLoading={save.isPending}
        width={600}
      >
        <Form form={form} layout="vertical" onFinish={(v) => save.mutate(v)}>
          <Row gutter={16}>
            <Col span={12}>
              <Form.Item name="nit" label="NIT" rules={[{ required: true }]}>
                <Input disabled={!!editId} />
              </Form.Item>
            </Col>
            <Col span={12}>
              <Form.Item name="tipo" label="Tipo" rules={[{ required: true }]}>
                <Select options={[
                  { value: 'C', label: 'Cliente' },
                  { value: 'P', label: 'Proveedor' },
                  { value: 'A', label: 'Ambos' },
                ]} />
              </Form.Item>
            </Col>
            <Col span={24}>
              <Form.Item name="nombre" label="Nombre" rules={[{ required: true }]}>
                <Input />
              </Form.Item>
            </Col>
            <Col span={12}>
              <Form.Item name="telefono" label="Teléfono">
                <Input />
              </Form.Item>
            </Col>
            <Col span={12}>
              <Form.Item name="diasCredito" label="Días de crédito">
                <InputNumber min={0} style={{ width: '100%' }} />
              </Form.Item>
            </Col>
            <Col span={24}>
              <Form.Item name="direccion" label="Dirección">
                <Input />
              </Form.Item>
            </Col>
          </Row>
        </Form>
      </Modal>
    </div>
  )
}

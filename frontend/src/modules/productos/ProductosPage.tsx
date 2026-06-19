import { useState } from 'react'
import {
  Table, Button, Tag, Space, Modal, Form, Input, InputNumber,
  message, Popconfirm, Card, Row, Col, Typography, Segmented,
} from 'antd'
import { PlusOutlined, EditOutlined, SearchOutlined } from '@ant-design/icons'
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { productosApi, type Producto } from '../../api/productos'

const { Title } = Typography

export default function ProductosPage() {
  const qc = useQueryClient()
  const [form] = Form.useForm()
  const [open, setOpen] = useState(false)
  const [editId, setEditId] = useState<number | null>(null)
  const [esServicio, setEsServicio] = useState<number | undefined>(undefined)
  const [q, setQ] = useState<string | undefined>(undefined)

  const { data = [], isLoading } = useQuery({
    queryKey: ['productos', esServicio, q],
    queryFn: () => productosApi.getAll(esServicio, q),
  })

  const save = useMutation({
    mutationFn: (values: Partial<Producto>) =>
      editId ? productosApi.update(editId, values) : productosApi.create(values),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['productos'] })
      message.success('Guardado')
      setOpen(false); form.resetFields(); setEditId(null)
    },
    onError: () => message.error('Error al guardar'),
  })

  const eliminar = useMutation({
    mutationFn: productosApi.delete,
    onSuccess: () => { qc.invalidateQueries({ queryKey: ['productos'] }); message.success('Eliminado') },
  })

  const openEdit = (rec: Producto) => {
    setEditId(rec.id); form.setFieldsValue(rec); setOpen(true)
  }

  const columns = [
    { title: 'Código', dataIndex: 'idProducto', width: 120 },
    { title: 'Descripción', dataIndex: 'descripcion', ellipsis: true },
    { title: 'Tipo', dataIndex: 'esServicio', width: 100,
      render: (v: number) => <Tag color={v ? 'purple' : 'cyan'}>{v ? 'Servicio' : 'Producto'}</Tag> },
    { title: 'Precio A', dataIndex: 'precioa', width: 100,
      render: (v: number) => v ? `Q ${v?.toFixed(2)}` : '-' },
    { title: 'Costo', dataIndex: 'costoPromedio', width: 100,
      render: (v: number) => v ? `Q ${v?.toFixed(2)}` : '-' },
    { title: 'Estado', dataIndex: 'estado', width: 90 },
    {
      title: '', key: 'a', width: 80,
      render: (_: any, rec: Producto) => (
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
          <Col><Title level={4} style={{ margin: 0 }}>Productos y Servicios</Title></Col>
          <Col>
            <Space>
              <Segmented
                options={[
                  { label: 'Todos', value: undefined as any },
                  { label: 'Servicios', value: 1 },
                  { label: 'Productos', value: 0 },
                ]}
                value={esServicio}
                onChange={(v) => setEsServicio(v as any)}
              />
              <Input.Search
                placeholder="Buscar..."
                onSearch={(v) => setQ(v || undefined)}
                allowClear
                style={{ width: 180 }}
                enterButton={<SearchOutlined />}
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
        title={editId ? 'Editar' : 'Nuevo Producto / Servicio'}
        open={open}
        onCancel={() => { setOpen(false); form.resetFields() }}
        onOk={() => form.submit()}
        confirmLoading={save.isPending}
        width={580}
      >
        <Form form={form} layout="vertical" onFinish={(v) => save.mutate(v)}>
          <Row gutter={16}>
            <Col span={12}>
              <Form.Item name="idProducto" label="Código" rules={[{ required: true }]}>
                <Input disabled={!!editId} maxLength={15} />
              </Form.Item>
            </Col>
            <Col span={12}>
              <Form.Item name="esServicio" label="Tipo" rules={[{ required: true }]}>
                <Segmented options={[{ label: 'Producto', value: 0 }, { label: 'Servicio', value: 1 }]} />
              </Form.Item>
            </Col>
            <Col span={24}>
              <Form.Item name="descripcion" label="Descripción" rules={[{ required: true }]}>
                <Input />
              </Form.Item>
            </Col>
            <Col span={12}>
              <Form.Item name="precioa" label="Precio">
                <InputNumber min={0} precision={2} style={{ width: '100%' }} prefix="Q" />
              </Form.Item>
            </Col>
            <Col span={12}>
              <Form.Item name="costoPromedio" label="Costo promedio">
                <InputNumber min={0} precision={5} style={{ width: '100%' }} prefix="Q" />
              </Form.Item>
            </Col>
          </Row>
        </Form>
      </Modal>
    </div>
  )
}

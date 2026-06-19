import { useState } from 'react'
import {
  Table, Button, Space, Modal, Form, Input,
  message, Popconfirm, Card, Row, Col, Typography,
} from 'antd'
import { PlusOutlined, EditOutlined, SearchOutlined } from '@ant-design/icons'
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import dayjs from 'dayjs'
import { vehiculosApi, type Vehiculo } from '../../api/vehiculos'

const { Title } = Typography

export default function VehiculosPage() {
  const qc = useQueryClient()
  const [form] = Form.useForm()
  const [open, setOpen] = useState(false)
  const [editId, setEditId] = useState<number | null>(null)
  const [nitSearch, setNitSearch] = useState<string | undefined>(undefined)

  const { data = [], isLoading } = useQuery({
    queryKey: ['vehiculos', nitSearch],
    queryFn: () => vehiculosApi.getAll(nitSearch),
  })

  const save = useMutation({
    mutationFn: (values: Partial<Vehiculo>) =>
      editId ? vehiculosApi.update(editId, values) : vehiculosApi.create(values),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['vehiculos'] })
      message.success('Guardado')
      setOpen(false); form.resetFields(); setEditId(null)
    },
    onError: () => message.error('Error al guardar'),
  })

  const eliminar = useMutation({
    mutationFn: vehiculosApi.delete,
    onSuccess: () => { qc.invalidateQueries({ queryKey: ['vehiculos'] }); message.success('Eliminado') },
  })

  const openEdit = (rec: Vehiculo) => {
    setEditId(rec.id); form.setFieldsValue(rec); setOpen(true)
  }

  const columns = [
    { title: 'Placa', dataIndex: 'numPlaca', width: 100 },
    { title: 'Marca', dataIndex: 'marca', width: 100 },
    { title: 'Línea', dataIndex: 'linea', width: 100 },
    { title: 'Modelo', dataIndex: 'modelo', width: 80 },
    { title: 'Color', dataIndex: 'color', width: 90 },
    { title: 'Motor', dataIndex: 'motor', width: 120 },
    { title: 'NIT cliente', dataIndex: 'nit', width: 120 },
    { title: 'Últ. mov.', dataIndex: 'fechaUltMov', width: 110,
      render: (v: string) => v ? dayjs(v).format('DD/MM/YYYY') : '-' },
    {
      title: '', key: 'a', width: 80,
      render: (_: any, rec: Vehiculo) => (
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
          <Col><Title level={4} style={{ margin: 0 }}>Vehículos</Title></Col>
          <Col>
            <Space>
              <Input.Search
                placeholder="Buscar por NIT"
                onSearch={(v) => setNitSearch(v || undefined)}
                allowClear
                style={{ width: 200 }}
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
        title={editId ? 'Editar Vehículo' : 'Nuevo Vehículo'}
        open={open}
        onCancel={() => { setOpen(false); form.resetFields() }}
        onOk={() => form.submit()}
        confirmLoading={save.isPending}
        width={600}
      >
        <Form form={form} layout="vertical" onFinish={(v) => save.mutate(v)}>
          <Row gutter={16}>
            <Col span={12}>
              <Form.Item name="numPlaca" label="Placa" rules={[{ required: true }]}>
                <Input disabled={!!editId} />
              </Form.Item>
            </Col>
            <Col span={12}>
              <Form.Item name="nit" label="NIT Cliente" rules={[{ required: true }]}>
                <Input />
              </Form.Item>
            </Col>
            <Col span={12}>
              <Form.Item name="marca" label="Marca"><Input /></Form.Item>
            </Col>
            <Col span={12}>
              <Form.Item name="linea" label="Línea"><Input /></Form.Item>
            </Col>
            <Col span={8}>
              <Form.Item name="modelo" label="Modelo"><Input maxLength={4} /></Form.Item>
            </Col>
            <Col span={8}>
              <Form.Item name="color" label="Color"><Input /></Form.Item>
            </Col>
            <Col span={8}>
              <Form.Item name="tipo" label="Tipo"><Input /></Form.Item>
            </Col>
            <Col span={12}>
              <Form.Item name="motor" label="N° Motor"><Input /></Form.Item>
            </Col>
            <Col span={12}>
              <Form.Item name="combustible" label="Combustible"><Input /></Form.Item>
            </Col>
          </Row>
        </Form>
      </Modal>
    </div>
  )
}

import { useState } from 'react'
import {
  Table, Button, Tag, Space, Modal, Form, Input, DatePicker,
  message, Popconfirm, Card, Row, Col, Typography, Select,
} from 'antd'
import { PlusOutlined, SwapOutlined, EyeOutlined } from '@ant-design/icons'
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import dayjs from 'dayjs'
import { presupuestosApi, type Presupuesto } from '../../api/presupuestos'

const { Title } = Typography

const statusColor: Record<number, string> = { 1: 'blue', 2: 'green' }
const statusLabel: Record<number, string> = { 1: 'Abierto', 2: 'Cerrado' }

export default function PresupuestosPage() {
  const qc = useQueryClient()
  const [form] = Form.useForm()
  const [open, setOpen] = useState(false)
  const [editId, setEditId] = useState<number | null>(null)
  const [statusFilter, setStatusFilter] = useState<number | undefined>(undefined)

  const { data: presupuestos = [], isLoading } = useQuery({
    queryKey: ['presupuestos', statusFilter],
    queryFn: () => presupuestosApi.getAll(statusFilter),
  })

  const save = useMutation({
    mutationFn: (values: Partial<Presupuesto>) =>
      editId ? presupuestosApi.update(editId, values) : presupuestosApi.create(values),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['presupuestos'] })
      message.success(editId ? 'Presupuesto actualizado' : 'Presupuesto creado')
      setOpen(false); form.resetFields(); setEditId(null)
    },
    onError: () => message.error('Error al guardar'),
  })

  const convertir = useMutation({
    mutationFn: presupuestosApi.convertir,
    onSuccess: (data) => {
      qc.invalidateQueries({ queryKey: ['presupuestos'] })
      message.success(`${data.mensaje} — OS #${data.idOrden}`)
    },
    onError: (e: any) => message.error(e.response?.data?.error ?? 'Error al convertir'),
  })

  const eliminar = useMutation({
    mutationFn: presupuestosApi.delete,
    onSuccess: () => { qc.invalidateQueries({ queryKey: ['presupuestos'] }); message.success('Eliminado') },
  })

  const openNew = () => { setEditId(null); form.resetFields(); setOpen(true) }
  const openEdit = (rec: Presupuesto) => {
    setEditId(rec.id)
    form.setFieldsValue({ ...rec, fecha: dayjs(rec.fecha) })
    setOpen(true)
  }

  const columns = [
    { title: 'N° Presup.', dataIndex: 'idOrden', width: 100 },
    { title: 'Placa', dataIndex: 'numPlaca', width: 100 },
    { title: 'Facturar a', dataIndex: 'facturarA', ellipsis: true },
    { title: 'NIT', dataIndex: 'nit', width: 120 },
    { title: 'Fecha', dataIndex: 'fecha', width: 110,
      render: (v: string) => dayjs(v).format('DD/MM/YYYY') },
    { title: 'Estado', dataIndex: 'status', width: 100,
      render: (s: number) => <Tag color={statusColor[s]}>{statusLabel[s]}</Tag> },
    {
      title: 'Acciones', key: 'accion', width: 140,
      render: (_: any, rec: Presupuesto) => (
        <Space size={4}>
          <Button size="small" icon={<EyeOutlined />} onClick={() => openEdit(rec)} />
          {rec.status === 2 && (
            <Popconfirm
              title="¿Convertir este presupuesto en Orden de Servicio?"
              onConfirm={() => convertir.mutate(rec.id)}
            >
              <Button size="small" type="primary" icon={<SwapOutlined />}>
                Convertir
              </Button>
            </Popconfirm>
          )}
          {rec.status === 1 && (
            <Popconfirm title="¿Eliminar presupuesto?" onConfirm={() => eliminar.mutate(rec.id)}>
              <Button size="small" danger>×</Button>
            </Popconfirm>
          )}
        </Space>
      ),
    },
  ]

  return (
    <div>
      <Card style={{ marginBottom: 16 }}>
        <Row justify="space-between" align="middle">
          <Col><Title level={4} style={{ margin: 0 }}>Presupuestos</Title></Col>
          <Col>
            <Space>
              <Select
                placeholder="Filtrar estado"
                allowClear
                style={{ width: 140 }}
                onChange={setStatusFilter}
                options={[
                  { value: 1, label: 'Abiertos' },
                  { value: 2, label: 'Cerrados' },
                ]}
              />
              <Button type="primary" icon={<PlusOutlined />} onClick={openNew}>
                Nuevo
              </Button>
            </Space>
          </Col>
        </Row>
      </Card>

      <Table
        rowKey="id"
        columns={columns}
        dataSource={presupuestos}
        loading={isLoading}
        size="small"
        pagination={{ pageSize: 20 }}
      />

      <Modal
        title={editId ? 'Editar Presupuesto' : 'Nuevo Presupuesto'}
        open={open}
        onCancel={() => { setOpen(false); form.resetFields() }}
        onOk={() => form.submit()}
        confirmLoading={save.isPending}
        width={580}
      >
        <Form form={form} layout="vertical" onFinish={(v) => save.mutate({ ...v, fecha: v.fecha?.toISOString() })}>
          <Row gutter={16}>
            <Col span={12}>
              <Form.Item name="numPlaca" label="Placa" rules={[{ required: true }]}>
                <Input />
              </Form.Item>
            </Col>
            <Col span={12}>
              <Form.Item name="nit" label="NIT" rules={[{ required: true }]}>
                <Input />
              </Form.Item>
            </Col>
            <Col span={24}>
              <Form.Item name="facturarA" label="Facturar a">
                <Input />
              </Form.Item>
            </Col>
            <Col span={12}>
              <Form.Item name="fecha" label="Fecha" rules={[{ required: true }]}>
                <DatePicker style={{ width: '100%' }} format="DD/MM/YYYY" />
              </Form.Item>
            </Col>
            <Col span={24}>
              <Form.Item name="observaciones" label="Observaciones">
                <Input.TextArea rows={2} />
              </Form.Item>
            </Col>
          </Row>
        </Form>
      </Modal>
    </div>
  )
}

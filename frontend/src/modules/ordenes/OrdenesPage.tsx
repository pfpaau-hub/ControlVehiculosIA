import { useState } from 'react'
import {
  Table, Button, Tag, Space, Modal, Form, Input, DatePicker,
  InputNumber, Select, message, Popconfirm, Card, Row, Col, Typography,
} from 'antd'
import { PlusOutlined, LockOutlined, UnlockOutlined, EyeOutlined } from '@ant-design/icons'
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import dayjs from 'dayjs'
import { ordenesApi, type OrdenServicio } from '../../api/ordenes'
import { proveedoresApi, type Proveedor } from '../../api/proveedores'
import { vehiculosApi, type Vehiculo } from '../../api/vehiculos'

const { Title } = Typography

const statusColor: Record<number, string> = { 1: 'green', 2: 'orange' }
const statusLabel: Record<number, string> = { 1: 'Abierta', 2: 'Cerrada' }

export default function OrdenesPage() {
  const qc = useQueryClient()
  const [form] = Form.useForm()
  const [open, setOpen] = useState(false)
  const [editId, setEditId] = useState<number | null>(null)
  const [statusFilter, setStatusFilter] = useState<number | undefined>(undefined)
  const [selectedNit, setSelectedNit] = useState<string | null>(null)

  const { data: ordenes = [], isLoading } = useQuery({
    queryKey: ['ordenes', statusFilter],
    queryFn: () => ordenesApi.getAll(statusFilter),
  })

  // Clientes para el selector de NIT
  const { data: clientes = [] } = useQuery<Proveedor[]>({
    queryKey: ['clientes-select'],
    queryFn: () => proveedoresApi.getAll('C'),
    staleTime: 60_000,
  })

  // Vehículos filtrados por el NIT seleccionado (igual que CBOPLACAS del VFP)
  const { data: vehiculosNit = [], isFetching: cargandoPlacas } = useQuery<Vehiculo[]>({
    queryKey: ['vehiculos-nit', selectedNit],
    queryFn: () => vehiculosApi.getAll(selectedNit ?? undefined),
    enabled: !!selectedNit,
    staleTime: 30_000,
  })

  const handleNitChange = (nit: string) => {
    const cliente = clientes.find((c) => c.nit === nit)
    if (cliente) {
      form.setFieldValue('facturarA', cliente.facturarA || cliente.nombre)
    }
    // Limpiar placa al cambiar NIT — las opciones disponibles cambian
    form.setFieldValue('numPlaca', undefined)
    setSelectedNit(nit)
  }

  const save = useMutation({
    mutationFn: (values: Partial<OrdenServicio>) =>
      editId ? ordenesApi.update(editId, values) : ordenesApi.create(values),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['ordenes'] })
      message.success(editId ? 'Orden actualizada' : 'Orden creada')
      setOpen(false)
      form.resetFields()
      setEditId(null)
    },
    onError: () => message.error('Error al guardar'),
  })

  const cerrar = useMutation({
    mutationFn: ordenesApi.cerrar,
    onSuccess: () => { qc.invalidateQueries({ queryKey: ['ordenes'] }); message.success('Orden cerrada') },
    onError: (e: any) => message.error(e.response?.data?.error ?? 'Error al cerrar'),
  })

  const reabrir = useMutation({
    mutationFn: ordenesApi.reabrir,
    onSuccess: () => { qc.invalidateQueries({ queryKey: ['ordenes'] }); message.success('Orden reabierta') },
    onError: (e: any) => message.error(e.response?.data?.error ?? 'Error al reabrir'),
  })

  const eliminar = useMutation({
    mutationFn: ordenesApi.delete,
    onSuccess: () => { qc.invalidateQueries({ queryKey: ['ordenes'] }); message.success('Orden eliminada') },
  })

  const openNew = () => {
    setEditId(null)
    setSelectedNit(null)
    form.resetFields()
    setOpen(true)
  }
  const openEdit = (rec: OrdenServicio) => {
    setEditId(rec.id)
    setSelectedNit(rec.nit)          // carga las placas del NIT de la OS existente
    form.setFieldsValue({ ...rec, fecha: dayjs(rec.fecha) })
    setOpen(true)
  }

  const onFinish = (values: any) => {
    save.mutate({ ...values, fecha: values.fecha?.toISOString() })
  }

  const columns = [
    { title: 'N° Orden', dataIndex: 'idOrden', width: 90, sorter: (a: OrdenServicio, b: OrdenServicio) => a.idOrden - b.idOrden },
    { title: 'Placa', dataIndex: 'numPlaca', width: 100 },
    { title: 'Cliente', dataIndex: 'facturarA', ellipsis: true },
    { title: 'NIT', dataIndex: 'nit', width: 120 },
    { title: 'Fecha', dataIndex: 'fecha', width: 110, render: (v: string) => dayjs(v).format('DD/MM/YYYY') },
    { title: 'Estado', dataIndex: 'status', width: 100,
      render: (s: number) => <Tag color={statusColor[s]}>{statusLabel[s]}</Tag> },
    { title: 'Factura', dataIndex: 'numero', width: 80,
      render: (n: number) => n > 0 ? <Tag color="blue">#{n}</Tag> : <Tag>Pendiente</Tag> },
    {
      title: 'Acciones', key: 'accion', width: 160,
      render: (_: any, rec: OrdenServicio) => (
        <Space size={4}>
          <Button size="small" icon={<EyeOutlined />} onClick={() => openEdit(rec)} />
          {rec.status === 1 && (
            <Popconfirm title="¿Cerrar orden?" onConfirm={() => cerrar.mutate(rec.id)}>
              <Button size="small" icon={<LockOutlined />} />
            </Popconfirm>
          )}
          {rec.status === 2 && rec.numero === 0 && (
            <Popconfirm title="¿Reabrir orden?" onConfirm={() => reabrir.mutate(rec.id)}>
              <Button size="small" icon={<UnlockOutlined />} />
            </Popconfirm>
          )}
          {rec.status === 1 && (
            <Popconfirm title="¿Eliminar orden?" onConfirm={() => eliminar.mutate(rec.id)}>
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
          <Col><Title level={4} style={{ margin: 0 }}>Órdenes de Servicio</Title></Col>
          <Col>
            <Space>
              <Select
                placeholder="Filtrar estado"
                allowClear
                style={{ width: 140 }}
                onChange={setStatusFilter}
                options={[
                  { value: 1, label: 'Abiertas' },
                  { value: 2, label: 'Cerradas' },
                ]}
              />
              <Button type="primary" icon={<PlusOutlined />} onClick={openNew}>
                Nueva OS
              </Button>
            </Space>
          </Col>
        </Row>
      </Card>

      <Table
        rowKey="id"
        columns={columns}
        dataSource={ordenes}
        loading={isLoading}
        size="small"
        pagination={{ pageSize: 20 }}
      />

      <Modal
        title={editId ? 'Editar Orden de Servicio' : 'Nueva Orden de Servicio'}
        open={open}
        onCancel={() => { setOpen(false); form.resetFields() }}
        onOk={() => form.submit()}
        confirmLoading={save.isPending}
        width={640}
      >
        <Form form={form} layout="vertical" onFinish={onFinish}>
          <Row gutter={16}>
            <Col span={12}>
              <Form.Item
                name="numPlaca"
                label="Número de Placa"
                rules={[{ required: true, message: 'Seleccione una placa' }]}
              >
                <Select
                  showSearch
                  loading={cargandoPlacas}
                  disabled={!selectedNit}
                  placeholder={selectedNit ? 'Seleccionar placa' : 'Primero seleccione un NIT'}
                  filterOption={(input, option) =>
                    (option?.value?.toString() ?? '').toLowerCase().includes(input.toLowerCase())
                  }
                  notFoundContent={
                    selectedNit
                      ? 'No hay vehículos registrados para este cliente'
                      : 'Seleccione un NIT primero'
                  }
                  options={vehiculosNit.map((v) => ({
                    value: v.numPlaca,
                    label: `${v.numPlaca}${v.marca ? ` — ${v.marca}` : ''}${v.modelo ? ` ${v.modelo}` : ''}`,
                  }))}
                />
              </Form.Item>
            </Col>
            <Col span={12}>
              <Form.Item
                name="nit"
                label="NIT"
                rules={[
                  { required: true, message: 'El NIT es requerido' },
                  {
                    validator: (_, value) => {
                      if (!value) return Promise.resolve()
                      const existe = clientes.some((c) => c.nit === value)
                      return existe
                        ? Promise.resolve()
                        : Promise.reject(new Error('NIT no encontrado. Regístrelo primero en Clientes'))
                    },
                  },
                ]}
              >
                <Select
                  showSearch
                  placeholder="Buscar por NIT o nombre"
                  onChange={handleNitChange}
                  filterOption={(input, option) =>
                    (option?.label?.toString() ?? '').toLowerCase().includes(input.toLowerCase()) ||
                    (option?.value?.toString() ?? '').toLowerCase().includes(input.toLowerCase())
                  }
                  options={clientes.map((c) => ({
                    value: c.nit,
                    label: `${c.nit} — ${c.nombre}`,
                  }))}
                />
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
            <Col span={12}>
              <Form.Item name="encargado" label="Encargado">
                <Input maxLength={4} />
              </Form.Item>
            </Col>
            <Col span={12}>
              <Form.Item name="recibeOrden" label="Recibe Orden">
                <Input maxLength={4} />
              </Form.Item>
            </Col>
            <Col span={12}>
              <Form.Item name="anticipo" label="Anticipo">
                <InputNumber style={{ width: '100%' }} min={0} precision={2} prefix="Q" />
              </Form.Item>
            </Col>
            <Col span={12}>
              <Form.Item name="lecturaActual" label="Lectura Actual (km)">
                <InputNumber style={{ width: '100%' }} min={0} />
              </Form.Item>
            </Col>
            <Col span={12}>
              <Form.Item name="proximoServicio" label="Próximo servicio (km)">
                <InputNumber style={{ width: '100%' }} min={0} />
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

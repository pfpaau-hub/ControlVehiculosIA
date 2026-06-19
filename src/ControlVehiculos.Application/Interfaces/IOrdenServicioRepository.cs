namespace ControlVehiculos.Application.Interfaces;

public interface IOrdenServicioRepository<T> where T : class
{
    Task<T?> GetByIdAsync(int id);
    Task<IEnumerable<T>> GetAllAsync(int? status = null);
    Task<T> CreateAsync(T entity);
    Task UpdateAsync(T entity);
    Task DeleteAsync(int id);
    Task<T?> CerrarAsync(int id);
    Task<T?> ReabrirAsync(int id);
}

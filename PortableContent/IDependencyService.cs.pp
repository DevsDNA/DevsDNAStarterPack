namespace $rootnamespace$.CommonServices
{
    /// <summary>
    /// Dependency Service abstraction interface to be able to mock implementation in tests.
    /// </summary>
    public interface IDependencyService
    {
        /// <summary>
        /// Returns instance of T form Dependency Service implementation.
        /// </summary>
        /// <typeparam name="T">Interface type to resolve class from</typeparam>
        /// <returns>Instance of T</returns>
        T Get<T>() where T : class;
    }
}

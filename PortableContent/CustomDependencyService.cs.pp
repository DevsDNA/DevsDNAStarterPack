namespace $rootnamespace$.CommonServices
{
    using Xamarin.Forms;

    /// <summary>
    /// App implementation for IDependencyService.
    /// </summary>
    public class CustomDependencyService : IDependencyService
    {
        /// <summary>
        /// <see cref="IDependencyService"/>
        /// </summary>
        /// <typeparam name="T"><see cref="IDependencyService"/></typeparam>
        /// <returns><see cref="IDependencyService"/></returns>
        public T Get<T>() where T : class
        {
            return DependencyService.Get<T>();
        }
    }
}

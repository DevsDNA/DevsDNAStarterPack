namespace $rootnamespace$.CommonServices
{
    using $rootnamespace$.Base;
    using System;
    using System.Threading.Tasks;
    using Xamarin.Forms;

    /// <summary>
    /// Navigation service contract definition.
    /// </summary>
    public interface INavigationService
    {
        /// <summary>
        /// Goes back in the navigation stack to the previous page.
        /// </summary>
        Task PopAsync();

        /// <summary>
        /// Goes forward in the navigation stack adding a new page to it.
        /// </summary>
        /// <param name="animated">Perform animation in the top page.</param>
        /// <param name="preserveCurrent">Preserve current top page.</param>
        /// <typeparam name="T">Page to navigate to.</typeparam>
        Task PushAsync<T>(bool animated = false, bool preserveCurrent = false) where T : Page;

        /// <summary>
        /// Goes forward in the navigation stack adding a new page to it and
        /// executing code to initialize values on the new page's viewmodel.
        /// </summary>
        /// <typeparam name="T">Page to navigate to.</typeparam>
        /// <typeparam name="U">ViewModel type.</typeparam>
        /// <param name="initialize">Action to execute for initialization.</param>
        Task PushAsync<T, U>(Action<U> initialize = null) where T : Page where U : BaseReactiveViewModel;

		/// <summary>
		/// Goes forward in the navigation stack adding a new page to it and
		/// executing code to initialize values on the new page's viewmodel.
		/// </summary>
		/// <typeparam name="T">Page to navigate to.</typeparam>
		/// <typeparam name="U">ViewModel type.</typeparam>
		/// <param name="animated">Perform animation in the top page.</param>
		/// <param name="preserveCurrent">Preserve current top page.</param>
		/// <param name="initialize">Action to execute for initialization.</param>
		Task PushAsync<T, U>(bool animated = false, bool preserveCurrent = false, Action < U> initialize = null) where T : Page where U : BaseReactiveViewModel;

		/// <summary>
		/// Reset navigation and goes to a new root page
		/// </summary>
		/// <typeparam name="T">Page to navigate to.</typeparam>
		void PushToRoot<T>() where T : Page;
    }
}

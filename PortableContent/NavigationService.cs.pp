[assembly:Xamarin.Forms.Dependency(typeof($rootnamespace$.CommonServices.NavigationService))]
namespace $rootnamespace$.CommonServices
{
    using System;
    using System.Linq;
    using System.Threading.Tasks;
    using $rootnamespace$.Base;
    using Xamarin.Forms;

    /// <summary>
    /// Navigation service shared implementation
    /// </summary>
    public class NavigationService : INavigationService
    {
        private INavigation FormsNavigation => Application.Current.MainPage.Navigation;

        /// <summary>
        /// Default constructor
        /// </summary>
        public NavigationService()
        {
        }

        /// <summary>
        /// <see cref="INavigationService"/>
        /// </summary>
        public async Task PopAsync()
        {
            await FormsNavigation.PopAsync(true);
        }

        /// <summary>
        /// <see cref="INavigationService"/>
        /// </summary>
        /// <param name="animated"><see cref="INavigationService"/></param>
        /// <param name="preserveCurrent"><see cref="INavigationService"/></param>
        /// <typeparam name="T"><see cref="INavigationService"/></typeparam>
        public async Task PushAsync<T>(bool animated = false, bool preserveCurrent = false) where T : Page
		{
			T view = Activator.CreateInstance<T>();
			await NavigateToPageAnimated(animated, preserveCurrent, view);
		}

		/// <summary>
		/// <see cref="INavigationService"/>
		/// </summary>
		/// <typeparam name="T"><see cref="INavigationService"/></typeparam>
		/// <typeparam name="U"><see cref="INavigationService"/></typeparam>
		/// <param name="animated"><see cref="INavigationService"/></param>
		/// <param name="preserveCurrent"><see cref="INavigationService"/></param>
		/// <param name="initialize"><see cref="INavigationService"/></param>
		/// <returns><see cref="INavigationService"/></returns>
		public async Task PushAsync<T, U>(bool animated = false, bool preserveCurrent = false, Action<U> initialize = null) where T : Page where U : BaseReactiveViewModel
		{
			T view = Activator.CreateInstance<T>();
			initialize?.Invoke((view as BaseReactiveContentPage<U>).ViewModel);
			await NavigateToPageAnimated(animated, preserveCurrent, view);
		}

		/// <summary>
		/// <see cref="INavigationService"/>
		/// </summary>
		/// <typeparam name="T"><see cref="INavigationService"/></typeparam>
		/// <typeparam name="U"><see cref="INavigationService"/></typeparam>
		/// <param name="initialize"><see cref="INavigationService"/></param>
		public async Task PushAsync<T, U>(Action<U> initialize = null) where T : Page where U : BaseReactiveViewModel
        {
            T view = Activator.CreateInstance<T>();
            initialize?.Invoke((view as BaseReactiveContentPage<U>).ViewModel);
            await FormsNavigation.PushAsync(view);
        }

        /// <summary>
        /// <see cref="INavigationService"/>
        /// </summary>
        /// <typeparam name="T"><see cref="INavigationService"/></typeparam>
        /// <returns><see cref="INavigationService"/></returns>
        public void PushToRoot<T>() where T : Page
        {
            T view = Activator.CreateInstance<T>();
            var navPage = new NavigationPage(view);
            navPage.BarTextColor = Color.White;
            App.Current.MainPage = navPage;
        }


		private async Task NavigateToPageAnimated<T>(bool animated, bool preserveCurrent, T view) where T : Page
		{
			if (animated)
			{
				var topView = (BaseAnimatedContentPage)FormsNavigation.NavigationStack.LastOrDefault();
				if (topView != null)
				{
					FormsNavigation.InsertPageBefore(view, FormsNavigation.NavigationStack.Last());
					await topView.PerformDissapearingAnimation();
					await FormsNavigation.PopAsync(false);
					if (preserveCurrent)
					{
						var oldView = Activator.CreateInstance(topView.GetType());
						FormsNavigation.InsertPageBefore((BaseAnimatedContentPage)oldView, FormsNavigation.NavigationStack.Last());
					}
				}
			}
			else
			{
				await FormsNavigation.PushAsync(view);
			}
		}
	}
}

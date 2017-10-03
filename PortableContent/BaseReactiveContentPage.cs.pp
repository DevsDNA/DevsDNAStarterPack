namespace $rootnamespace$.Base
{
    using ReactiveUI;
    using System;
    using Xamarin.Forms;

    /// <summary>
    /// Base reactive view for content page.
    /// </summary>
    /// <typeparam name="T"></typeparam>
    /// <seealso cref="Xamarin.Forms.ContentPage" />
    /// <seealso cref="ReactiveUI.IViewFor{T}" />
    public class BaseReactiveContentPage<T> : BaseAnimatedContentPage, IViewFor<T> where T : BaseReactiveViewModel
    {
        private bool bindingInitialized = false;

        /// <summary>
        /// Initializes a new instance of the <see cref="BaseReactiveContentPage{T}"/> class.
        /// </summary>
        public BaseReactiveContentPage()
        {
            var viewModel = Activator.CreateInstance(typeof(T));
            BindingContext = viewModel;
        }

        /// <summary>
        /// The ViewModel corresponding to this specific View. This should be
        /// a DependencyProperty if you're using XAML.
        /// </summary>
        public T ViewModel
        {
            get { return (T)GetValue(BindingContextProperty); }
            set { SetValue(BindingContextProperty, value); }
        }

        /// <summary>
        /// The ViewModel corresponding to this specific View. This should be
        /// a DependencyProperty if you're using XAML.
        /// </summary>
        object IViewFor.ViewModel
        {
            get { return (T)ViewModel; }
            set { ViewModel = (T)value; }
        }

        /// <summary>
        /// Creates the data bindings.
        /// </summary>
        protected virtual void CreateBindings() { }

        /// <summary>
        /// When overridden, allows application developers to customize behavior immediately prior to the <see cref="T:Xamarin.Forms.Page" /> becoming visible.
        /// </summary>
        protected override async void OnAppearing()
        {
            base.OnAppearing();

			if (!bindingInitialized)
            {
                bindingInitialized = true;
                CreateBindings();
            }

			if (ViewModel != null)
				await ViewModel.AppearingAsync();
		}

        /// <summary>
        /// When overridden, allows the application developer to customize behavior as the <see cref="T:Xamarin.Forms.Page" /> disappears.
        /// </summary>
        protected override void OnDisappearing()
        {
            base.OnDisappearing();
            if (ViewModel != null)
                ViewModel.Dissapearing();
        }
    }
}

namespace $rootnamespace$.Base
{
    using $rootnamespace$.CommonServices;
    using $rootnamespace$.XamlExtensions;
    using ReactiveUI;
    using System;
    using System.Threading.Tasks;

    public class BaseReactiveViewModel : ReactiveObject
    {
        protected IDependencyService dependencyService;
        private readonly IConnectionService connectionService;
        private readonly IDialogService dialogService;
        protected readonly INavigationService navigationService;
        protected ObservableAsPropertyHelper<bool> isLoading;

        /// <summary>
        /// Default constructor
        /// </summary>
        public BaseReactiveViewModel(IDependencyService dependencyService)
        {
            this.dependencyService = dependencyService;
            connectionService = this.dependencyService.Get<IConnectionService>();
            dialogService = this.dependencyService.Get<IDialogService>();
            navigationService = this.dependencyService.Get<INavigationService>();

            InitializeCommand();
        }

        public bool IsLoading
        {
            get { return isLoading?.Value ?? false; }
        }

        /// <summary>
        /// Is called when the view is appearing.
        /// </summary>
        public virtual async Task AppearingAsync() { }

        /// <summary>
        /// Is called when the view is dissppearing.
        /// </summary>
        public virtual void Dissapearing() { }

        /// <summary>
        /// Initializes the command.
        /// </summary>
        protected virtual void InitializeCommand() { }

        /// <summary>
        /// Executes internet bound calls from a ViewModel.
        /// </summary>
        /// <param name="operation">The operation.</param>
        protected async Task<T> ExecuteInternetBoundCallAsync<T>(Func<Task<T>> operation)
        {
            if (!connectionService.HasConnection())
            {
                await dialogService.ShowDialogAsync(TranslateExtension.GetText("NoInternetTitle"), 
                                                    TranslateExtension.GetText("NoInternetDesc"), 
                                                    TranslateExtension.GetText("OkLowerCase"));
                return default(T);
            }

            try
            {
                return await operation();
            }
            catch (Exception ex)
            {
				var x = ex.Message;
                await dialogService.ShowDialogAsync(TranslateExtension.GetText("InternetCallErrorTitle"),
                                                    TranslateExtension.GetText("InternetCallErrorDesc"),
                                                    TranslateExtension.GetText("OkLowerCase"));
				return default(T);
            }
        }
    }
}

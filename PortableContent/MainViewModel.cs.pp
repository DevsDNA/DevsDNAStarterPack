namespace $rootnamespace$.Features.Main
{
    using $rootnamespace$.Base;    
    using ReactiveUI;
    using System.Collections.Generic;
    using System.Linq;
    using System.Reactive;
    using System.Threading.Tasks;

    /// <summary>
    /// Main assessment summary ViewModel
    /// </summary>
    public class MainViewModel : BaseReactiveViewModel
    {		
		/// <summary>
		/// Default constructor for xaml instantiated viewmodels.
		/// </summary>
		public MainViewModel() : this (new CustomDependencyService())
        {
        }

        /// <summary>
        /// Constructor used from unit tests to mock dependency service.
        /// </summary>
        /// <param name="dependencyService">Custom dependency service abstraction</param>
        public MainViewModel(IDependencyService dependencyService) : base(dependencyService)
        {
			
        }         
}

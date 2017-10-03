[assembly: Xamarin.Forms.Dependency(typeof($rootnamespace$.CommonServices.DialogService))]
namespace $rootnamespace$.CommonServices
{
    using System.Threading.Tasks;
    using Xamarin.Forms;

    /// <summary>
    /// Dialog service common implementation
    /// </summary>
    public class DialogService : IDialogService
    {
        /// <summary>
        /// <see cref="IDialogService"/>
        /// </summary>
        /// <param name="title"><see cref="IDialogService"/></param>
        /// <param name="message"><see cref="IDialogService"/></param>
        /// <param name="cancel"><see cref="IDialogService"/></param>
        public async Task ShowDialogAsync(string title, string message, string cancel)
        {
            await Application.Current.MainPage.DisplayAlert(title, message, cancel);
        }
    }
}
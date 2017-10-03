namespace $rootnamespace$.CommonServices
{
    using System.Threading.Tasks;

    /// <summary>
    /// Dialog service contract definition
    /// </summary>
    public interface IDialogService
    {
        /// <summary>
        /// Show a dialog box with title, message and ok button.
        /// </summary>
        /// <param name="title">Title to show.</param>
        /// <param name="message">Message to show.</param>
        /// <param name="cancel">Cancel button text.</param>
        Task ShowDialogAsync(string title, string message, string cancel);
    }
}

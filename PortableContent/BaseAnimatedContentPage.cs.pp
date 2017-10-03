namespace $rootnamespace$.Base
{
    using System.Threading.Tasks;
    using Xamarin.Forms;

    /// <summary>
    /// Base class to perform animations on page.
    /// </summary>
    public class BaseAnimatedContentPage : ContentPage
    {
        /// <summary>
        /// Invoked from navigation service to perform a closing animation.
        /// </summary>
        internal virtual Task PerformDissapearingAnimation() { return null; }
    }
}

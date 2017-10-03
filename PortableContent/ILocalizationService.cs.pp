namespace $rootnamespace$.CommonServices
{
    using System.Globalization;

    /// <summary>
    /// Localization service contract definition.
    /// </summary>
    public interface ILocalizationService
    {
        ///	<summary>
        /// This method must evaluate platform-specific locale settings
        /// and convert them (when necessary) to a valid .NET locale.
        /// </summary>
        CultureInfo GetCurrentCultureInfo();

        /// <summary>
        /// CurrentCulture and CurrentUICulture must be set in the platform project, 
        /// because the Thread object can't be accessed in a PCL.
        /// </summary>
        void SetLocale(CultureInfo ci);
    }
}

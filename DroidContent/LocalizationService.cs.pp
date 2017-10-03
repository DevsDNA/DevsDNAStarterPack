[assembly:Xamarin.Forms.Dependency(typeof($rootnamespaces$.CommonServices.LocalizationService))]
namespace $rootnamespaces$.CommonServices
{    
    using System.Globalization;
    using System.Threading;

    /// <summary>
    /// Localization service Android implementation.
    /// </summary>
    public class LocalizationService : ILocalizationService
    {
        private static CultureInfo currentCultureInfo;

        /// <summary>
        /// <see cref="ILocalizationService"/>
        /// </summary>
        /// <param name="cultureInfo"><see cref="ILocalizationService"/></param>
        public void SetLocale(CultureInfo cultureInfo)
        {
            Thread.CurrentThread.CurrentCulture = cultureInfo;
            Thread.CurrentThread.CurrentUICulture = cultureInfo;
        }

        /// <summary>
        /// <see cref="ILocalizationService"/>
        /// </summary>
        /// <param name="cultureInfo"><see cref="ILocalizationService"/></param>
        public CultureInfo GetCurrentCultureInfo()
        {
            if (currentCultureInfo != null)
                return currentCultureInfo;

            var netLanguage = "es";
            var androidLocale = Java.Util.Locale.Default;
            netLanguage = AndroidToDotnetLanguage(androidLocale.ToString().Replace("_", "-"));
            try
            {
                currentCultureInfo = new CultureInfo(netLanguage);
            }
            catch (CultureNotFoundException)
            {
                try
                {
                    var fallback = ToDotnetFallbackLanguage(new PlatformCulture(netLanguage));
                    currentCultureInfo = new CultureInfo(fallback);
                }
                catch (CultureNotFoundException)
                {
                    currentCultureInfo = new CultureInfo("en");
                }
            }
            return currentCultureInfo;
        }

        private string AndroidToDotnetLanguage(string androidLanguage)
        {
            var netLanguage = androidLanguage;
            switch (androidLanguage)
            {
                case "ms-BN":
                case "ms-MY":
                case "ms-SG":
                    netLanguage = "ms";
                    break;
                case "in-ID":
                    netLanguage = "id-ID";
                    break;
                case "gsw-CH":
                    netLanguage = "de-CH";
                    break;
            }
            return netLanguage;
        }

        private string ToDotnetFallbackLanguage(PlatformCulture platCulture)
        {
            var netLanguage = platCulture.LanguageCode;
            switch (platCulture.LanguageCode)
            {
                case "gsw":
                    netLanguage = "de-CH";
                    break;
            }
            return netLanguage;
        }
    }
}
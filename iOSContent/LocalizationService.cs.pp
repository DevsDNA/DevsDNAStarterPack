[assembly: Xamarin.Forms.Dependency(typeof($rootnamespace$.CommonServices.LocalizationService))]
namespace $rootnamespace$.CommonServices
{
    using Foundation;    
    using System.Globalization;
    using System.Threading;

    /// <summary>
    /// Localization service iOS implementation.
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
        /// <returns><see cref="ILocalizationService"/></returns>
        public CultureInfo GetCurrentCultureInfo()
        {
            if (currentCultureInfo != null)
                return currentCultureInfo;

            var netLanguage = "en";
            if (NSLocale.PreferredLanguages.Length > 0)
            {
                var pref = NSLocale.PreferredLanguages[0];

                netLanguage = iOSToDotnetLanguage(pref);
            }

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

        private string iOSToDotnetLanguage(string iOSLanguage)
        {
            var netLanguage = iOSLanguage;
            switch (iOSLanguage)
            {
                case "ms-MY":
                case "ms-SG":
                    netLanguage = "ms";
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
                // 
                case "pt":
                    netLanguage = "pt-PT";
                    break;
                case "gsw":
                    netLanguage = "de-CH";
                    break;
            }
            return netLanguage;
        }
    }
}
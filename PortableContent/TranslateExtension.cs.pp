namespace $rootnamespace$.XamlExtensions
{
    using System;
    using System.Reflection;
    using System.Globalization;
    using System.Resources;
    using Xamarin.Forms;
    using Xamarin.Forms.Xaml;
    using $rootnamespace$.CommonServices;

    [ContentProperty("Text")]
    public class TranslateExtension : IMarkupExtension
    {
        private const string RESOURCE_ID = "$rootnamespace$.App.Strings.Strings";
        private static CultureInfo ci = null;
        private static ResourceManager resManager = null;

        public TranslateExtension()
        {
            ci = DependencyService.Get<ILocalizationService>().GetCurrentCultureInfo();
        }

        public string Text { get; set; }

        public object ProvideValue(IServiceProvider serviceProvider)
        {
            if (Text == null)
                return string.Empty;

            return GetText(Text);
        }

        public static string GetText(string text)
        {
            if (resManager == null)
                resManager = new ResourceManager(RESOURCE_ID, typeof(TranslateExtension).GetTypeInfo().Assembly);
            if (ci == null)
                ci = DependencyService.Get<ILocalizationService>().GetCurrentCultureInfo();

            var translation = resManager.GetString(text, ci);
            if (translation == null)
            {
                translation = text;
            }
            return translation;
        }
    }
}

using Android.App;
using Android.Content.PM;
using Android.Support.V7.App;

namespace $rootnamespace$
{
    [Activity(Label = "$rootnamespace$", Icon = "@drawable/icon", Theme = "@style/MyTheme.SplashScreen", MainLauncher = true, NoHistory = true, ScreenOrientation = ScreenOrientation.Portrait)]
    public class SplashActivity : AppCompatActivity
    {
        protected override void OnResume()
        {
            base.OnResume();

            StartActivity(typeof(MainActivity));
        }
    }
}
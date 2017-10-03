/*
    namespace for this security class need to be with first letter in lowercase or multidex will complaint
    about not finding it.
 */
namespace $rootnamespaces$.KeyStore
{
    using System.Text;
    using Javax.Crypto;

    /// <summary>
    /// Stores a secured entry for keystore.
    /// </summary>
    public class StringKeyEntry : Java.Lang.Object, ISecretKey
    {
        private const string AlgorithmName = "RAW";
        private byte[] _bytes;

        /// <summary>
        /// Constructor makes sure that entry is valid.
        /// Converts it to bytes
        /// </summary>
        /// <param name="entry">Entry.</param>
        public StringKeyEntry(string entry)
        {
            if (entry == null)
                return;

            _bytes = Encoding.UTF8.GetBytes(entry);
        }

        /// <summary>
        /// Gets the encoded.
        /// </summary>
        /// <returns>The encoded.</returns>
        public byte[] GetEncoded()
        {
            return _bytes;
        }

        /// <summary>
        /// Gets the algorithm.
        /// </summary>
        /// <value>The algorithm.</value>
        public string Algorithm
        {
            get
            {
                return AlgorithmName;
            }
        }

        /// <summary>
        /// Gets the format.
        /// </summary>
        /// <value>The format.</value>
        public string Format
        {
            get
            {
                return AlgorithmName;
            }
        }
    }
}
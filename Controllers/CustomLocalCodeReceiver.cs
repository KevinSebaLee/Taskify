using Google.Apis.Auth.OAuth2.Responses;
using Google.Apis.Auth.OAuth2.Requests;
using Google.Apis.Auth.OAuth2;
using Google.Apis.Util;
using System;
using System.Threading;
using System.Threading.Tasks;

namespace Taskify.Controllers
{
    public class CustomLocalServerCodeReceiver : ICodeReceiver
    {
        public string RedirectUri { get; private set; }
        private readonly LocalServerCodeReceiver _receiver;

        public CustomLocalServerCodeReceiver(string redirectUri)
        {
            RedirectUri = redirectUri;
            _receiver = new LocalServerCodeReceiver();
        }

        public async Task<AuthorizationCodeResponseUrl> ReceiveCodeAsync(AuthorizationCodeRequestUrl url, CancellationToken taskCancellationToken)
        {
            var modifiedUrl = new AuthorizationCodeRequestUrl(url.AuthorizationServerUrl)
            {
                ClientId = url.ClientId,
                Scope = url.Scope,
                RedirectUri = RedirectUri,
                State = url.State
            };

            return await _receiver.ReceiveCodeAsync(modifiedUrl, taskCancellationToken);
        }
    }
}
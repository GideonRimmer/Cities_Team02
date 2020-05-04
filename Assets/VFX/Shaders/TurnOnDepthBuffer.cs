using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class TurnOnDepthBuffer : MonoBehaviour
{
    // Use this for initialization
    void Start()
    {
        GetComponent<Camera>().depthTextureMode = DepthTextureMode.Depth;
    }
}
